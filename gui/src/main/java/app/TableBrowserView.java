package app;

import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.geometry.Insets;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import java.sql.*;
import java.util.*;
import java.util.stream.Collectors;

public class TableBrowserView extends BorderPane {

    private final ComboBox<String> tableCombo = new ComboBox<>();
    private final Button loadBtn = new Button("Load / Refresh");
    private final TableView<ObservableList<String>> tableView = new TableView<>();
    private final VBox formBox = new VBox(8);
    private final Map<String, Control> editors = new HashMap<>();
    private List<String> colNames = new ArrayList<>();
    private Set<String> autoIncrementCols = new HashSet<>();
    private List<String> pkCols = new ArrayList<>();
    private Map<String, String[]> fkInfo = new HashMap<>();
    private Map<String, List<String>> enumInfo = new HashMap<>();
    private final Spinner<Integer> capacitySpinner = new Spinner<>(1, 60, 10);
    private final Button filterBtn = new Button("Filter by Capacity");
    private final Button clearFilterBtn = new Button("Clear Filter");
    private boolean capacityFilterActive = false;

    public TableBrowserView() {
        setPadding(new Insets(12));
        var top = new HBox(10, new Label("Table:"), tableCombo, loadBtn);
        top.setPadding(new Insets(0, 0, 12, 0));
        setTop(top);
        var split = new SplitPane();
        split.getItems().addAll(new VBox(tableView), wrapForm());
        split.setDividerPositions(0.70);
        setCenter(split);
        loadBtn.setOnAction(e -> loadSelectedTable());
        tableCombo.setOnAction(e -> {
            capacityFilterActive = false;
            loadSelectedTable();
        });
        tableView.getSelectionModel().selectedItemProperty().addListener((obs, old, row) -> {
            if (row != null) fillFormFromRow(row);
        });
        initTables();
    }

    private Pane wrapForm() {
        formBox.setPadding(new Insets(10));
        var scroll = new ScrollPane(formBox);
        scroll.setFitToWidth(true);

        var insertBtn = new Button("Insert");
        var updateBtn = new Button("Update");
        var deleteBtn = new Button("Delete");
        var btns = new HBox(10, insertBtn, updateBtn, deleteBtn);

        insertBtn.setOnAction(e -> insertRow());
        updateBtn.setOnAction(e -> updateRow());
        deleteBtn.setOnAction(e -> deleteRow());
        capacitySpinner.setEditable(true);
        capacitySpinner.setPrefWidth(80);
        var filterBox = new HBox(8, new Label("Min Seats:"), capacitySpinner, filterBtn, clearFilterBtn);
        filterBox.setPadding(new Insets(8, 0, 8, 0));
        filterBox.setVisible(false);
        filterBox.setManaged(false);

        filterBtn.setOnAction(e -> {
            capacityFilterActive = true;
            loadSelectedTable();
        });
        clearFilterBtn.setOnAction(e -> {
            capacityFilterActive = false;
            loadSelectedTable();
        });
        var box = new VBox(12, new Label("Row editor"), scroll, filterBox, btns);
        box.setPadding(new Insets(0, 0, 0, 12));
        VBox.setVgrow(scroll, Priority.ALWAYS);
        box.setUserData(filterBox);

        return box;
    }

    private void initTables() {
        try (Connection c = Db.get()) {
            DatabaseMetaData md = c.getMetaData();
            ResultSet rs = md.getTables(c.getCatalog(), null, "%", new String[]{"TABLE"});
            var tables = new ArrayList<String>();
            while (rs.next()) tables.add(rs.getString("TABLE_NAME"));
            tables.sort(String::compareToIgnoreCase);
            tableCombo.setItems(FXCollections.observableArrayList(tables));
            if (!tables.isEmpty()) tableCombo.getSelectionModel().select(0);
            loadSelectedTable();
        } catch (SQLException ex) {
            showError("DB error while listing tables", ex);
        }
    }

    private void loadSelectedTable() {
        String table = tableCombo.getValue();
        if (table == null) return;
        try (Connection c = Db.get()) {
            colNames.clear();
            autoIncrementCols.clear();
            pkCols.clear();
            editors.clear();
            fkInfo.clear();
            enumInfo.clear();
            formBox.getChildren().clear();

            DatabaseMetaData md = c.getMetaData();
            toggleCapacityFilter(table.equalsIgnoreCase("vehicle"));

            try (ResultSet pk = md.getPrimaryKeys(c.getCatalog(), null, table)) {
                Map<Short, String> seqToCol = new TreeMap<>();
                while (pk.next()) {
                    seqToCol.put(pk.getShort("KEY_SEQ"), pk.getString("COLUMN_NAME"));
                }
                pkCols.addAll(seqToCol.values());
            }
            try (ResultSet fks = md.getImportedKeys(c.getCatalog(), null, table)) {
                while (fks.next()) {
                    String fkColumn = fks.getString("FKCOLUMN_NAME");
                    String pkTable = fks.getString("PKTABLE_NAME");
                    String pkColumn = fks.getString("PKCOLUMN_NAME");
                    fkInfo.put(fkColumn, new String[]{pkTable, pkColumn});
                }
            }
            try (ResultSet cols = md.getColumns(c.getCatalog(), null, table, "%")) {
                while (cols.next()) {
                    String name = cols.getString("COLUMN_NAME");
                    colNames.add(name);
                    String isAuto = cols.getString("IS_AUTOINCREMENT");
                    if ("YES".equalsIgnoreCase(isAuto)) autoIncrementCols.add(name);
                    String typeName = cols.getString("TYPE_NAME");
                    if (typeName != null && typeName.toUpperCase().startsWith("ENUM")) {
                        List<String> enumValues = fetchEnumValues(c, table, name);
                        if (!enumValues.isEmpty()) {
                            enumInfo.put(name, enumValues);
                        }
                    }

                    boolean isPK = pkCols.contains(name);
                    boolean isAI = autoIncrementCols.contains(name);
                    boolean isFK = fkInfo.containsKey(name);
                    boolean isEnum = enumInfo.containsKey(name);
                    Control editor;
                    if (isEnum) {
                        ComboBox<String> combo = new ComboBox<>();
                        combo.getItems().addAll(enumInfo.get(name));
                        combo.setMaxWidth(Double.MAX_VALUE);
                        editor = combo;
                    } else if (isFK && !isAI) {
                        ComboBox<String> combo = new ComboBox<>();
                        String[] ref = fkInfo.get(name);
                        populateFKComboBox(c, combo, ref[0], ref[1]);
                        combo.setMaxWidth(Double.MAX_VALUE);
                        editor = combo;
                    } else {
                        TextField tf = new TextField();
                        tf.setPromptText(name);
                        editor = tf;
                    }
                    editors.put(name, editor);
                    String tag = (isPK ? " (PK)" : "") + (isAI ? " (AUTO)" : "") +
                                 (isFK && !isAI ? " (FK)" : "") + (isEnum ? " (ENUM)" : "");

                    formBox.getChildren().add(new VBox(4, new Label(name + tag), editor));
                }
            }
            buildTableViewColumns();

            String sql;
            if (table.equalsIgnoreCase("vehicle") && capacityFilterActive) {
                sql = "SELECT * FROM " + table + " WHERE veh_capacity >= ?";
            } else {
                sql = "SELECT * FROM " + table;
            }
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                if (table.equalsIgnoreCase("vehicle") && capacityFilterActive) {
                    ps.setInt(1, capacitySpinner.getValue());
                }
                try (ResultSet rs = ps.executeQuery()) {
                    ObservableList<ObservableList<String>> data = FXCollections.observableArrayList();
                    while (rs.next()) {
                        ObservableList<String> row = FXCollections.observableArrayList();
                        for (String col : colNames) {
                            Object v = rs.getObject(col);
                            row.add(v == null ? "" : String.valueOf(v));
                        }
                        data.add(row);
                    }
                    tableView.setItems(data);
                }
            }
        } catch (SQLException ex) {
            showError("DB error while loading table: " + table, ex);
        }
    }

    private void toggleCapacityFilter(boolean show) {
        var formParent = formBox.getParent();
        if (formParent instanceof ScrollPane) {
            var scroll = (ScrollPane) formParent;
            if (scroll.getParent() instanceof VBox) {
                var box = (VBox) scroll.getParent();
                var filterBox = (HBox) box.getUserData();
                if (filterBox != null) {
                    filterBox.setVisible(show);
                    filterBox.setManaged(show);
                }
            }
        }
    }

    private List<String> fetchEnumValues(Connection c, String table, String column) {
        List<String> values = new ArrayList<>();
        try {
            String sql = "SHOW COLUMNS FROM " + table + " WHERE Field = ?";
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setString(1, column);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String type = rs.getString("Type");
                        if (type != null && type.startsWith("enum(")) {
                            String inner = type.substring(5, type.length() - 1);
                            String[] parts = inner.split(",");
                            for (String p : parts) {
                                values.add(p.trim().replace("'", ""));
                            }
                        }
                    }
                }
            }
        } catch (SQLException ex) {
        }
        return values;
    }

    private void populateFKComboBox(Connection c, ComboBox<String> combo, String refTable, String refColumn) {
        try {
            String displayColumn = findDisplayColumn(c, refTable);
            String sql;
            if (displayColumn != null) {
                sql = "SELECT " + refColumn + ", " + displayColumn + " FROM " + refTable;
            } else {
                sql = "SELECT " + refColumn + " FROM " + refTable;
            }
            try (PreparedStatement ps = c.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                List<String> items = new ArrayList<>();
                items.add("");
                while (rs.next()) {
                    String pk = rs.getString(1);
                    if (displayColumn != null) {
                        String display = rs.getString(2);
                        items.add(pk + " (" + (display != null ? display : "") + ")");
                    } else {
                        items.add(pk);
                    }
                }
                combo.setItems(FXCollections.observableArrayList(items));
            }
        } catch (SQLException ex) {
            combo.setItems(FXCollections.observableArrayList(""));
        }
    }

    private String findDisplayColumn(Connection c, String table) throws SQLException {
        DatabaseMetaData md = c.getMetaData();
        try (ResultSet cols = md.getColumns(c.getCatalog(), null, table, "%")) {
            while (cols.next()) {
                String colName = cols.getString("COLUMN_NAME").toLowerCase();
                if (colName.contains("name") || colName.contains("title") ||
                    colName.contains("plate") || colName.contains("descr")) {
                    return cols.getString("COLUMN_NAME");
                }
            }
        }
        return null;
    }

    private void buildTableViewColumns() {
        tableView.getColumns().clear();
        for (int i = 0; i < colNames.size(); i++) {
            final int idx = i;
            TableColumn<ObservableList<String>, String> col = new TableColumn<>(colNames.get(i));
            col.setCellValueFactory(param -> new SimpleStringProperty(param.getValue().get(idx)));
            tableView.getColumns().add(col);
        }
    }

    private void fillFormFromRow(ObservableList<String> row) {
        for (int i = 0; i < colNames.size(); i++) {
            String colName = colNames.get(i);
            Control editor = editors.get(colName);
            String value = row.get(i);
            if (editor instanceof TextField) {
                ((TextField) editor).setText(value);
            } else if (editor instanceof ComboBox) {
                @SuppressWarnings("unchecked")
                ComboBox<String> combo = (ComboBox<String>) editor;
                String match = combo.getItems().stream()
                        .filter(item -> item.equals(value) || item.startsWith(value + " ("))
                        .findFirst()
                        .orElse(value);
                combo.setValue(match);
            }
        }
    }

    private String getEditorValue(String colName) {
        Control editor = editors.get(colName);
        if (editor instanceof TextField) {
            return ((TextField) editor).getText().trim();
        } else if (editor instanceof ComboBox) {
            @SuppressWarnings("unchecked")
            ComboBox<String> combo = (ComboBox<String>) editor;
            String val = combo.getValue();
            if (val == null || val.isEmpty()) return "";
            int parenIdx = val.indexOf(" (");
            return parenIdx > 0 ? val.substring(0, parenIdx) : val;
        }
        return "";
    }

    private void insertRow() {
        String table = tableCombo.getValue();
        if (table == null) return;
        try (Connection c = Db.get()) {
            List<String> insertCols = colNames.stream()
                    .filter(cn -> !autoIncrementCols.contains(cn))
                    .toList();
            String placeholders = String.join(",", Collections.nCopies(insertCols.size(), "?"));
            String sql = "INSERT INTO " + table +
                    " (" + String.join(",", insertCols) + ") VALUES (" + placeholders + ")";
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                for (int i = 0; i < insertCols.size(); i++) {
                    String val = getEditorValue(insertCols.get(i));
                    if (val.isEmpty()) {
                        ps.setNull(i + 1, Types.VARCHAR);
                    } else {
                        ps.setString(i + 1, val);
                    }
                }
                ps.executeUpdate();
            }
            loadSelectedTable();
            clearForm();
        } catch (SQLException ex) {
            showError("Insert failed", ex);
        }
    }

    private void updateRow() {
        String table = tableCombo.getValue();
        if (table == null) return;

        if (pkCols.isEmpty()) {
            showInfo("Update not possible", "This table has no primary key detected.");
            return;
        }

        try (Connection c = Db.get()) {
            List<String> updCols = colNames.stream()
                    .filter(cn -> !pkCols.contains(cn))
                    .filter(cn -> !autoIncrementCols.contains(cn))
                    .toList();

            String setPart = updCols.stream().map(x -> x + "=?").collect(Collectors.joining(","));
            String wherePart = pkCols.stream().map(x -> x + "=?").collect(Collectors.joining(" AND "));
            String sql = "UPDATE " + table + " SET " + setPart + " WHERE " + wherePart;

            try (PreparedStatement ps = c.prepareStatement(sql)) {
                int k = 1;
                for (String col : updCols) {
                    String val = getEditorValue(col);
                    if (val.isEmpty()) {
                        ps.setNull(k++, Types.VARCHAR);
                    } else {
                        ps.setString(k++, val);
                    }
                }
                for (String pk : pkCols) {
                    ps.setString(k++, getEditorValue(pk));
                }
                ps.executeUpdate();
            }
            loadSelectedTable();
        } catch (SQLException ex) {
            showError("Update failed", ex);
        }
    }

    private void deleteRow() {
        String table = tableCombo.getValue();
        if (table == null) return;
        if (pkCols.isEmpty()) {
            showInfo("Delete not possible", "This table has no primary key detected.");
            return;
        }
        try (Connection c = Db.get()) {
            String wherePart = pkCols.stream().map(x -> x + "=?").collect(Collectors.joining(" AND "));
            String sql = "DELETE FROM " + table + " WHERE " + wherePart;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                int k = 1;
                for (String pk : pkCols) {
                    ps.setString(k++, getEditorValue(pk));
                }
                ps.executeUpdate();
            }
            loadSelectedTable();
            clearForm();
        } catch (SQLException ex) {
            showError("Delete failed", ex);
        }
    }

    private void clearForm() {
        for (Control editor : editors.values()) {
            if (editor instanceof TextField) {
                ((TextField) editor).setText("");
            } else if (editor instanceof ComboBox) {
                ((ComboBox<?>) editor).setValue(null);
            }
        }
    }

    private void showError(String title, Exception ex) {
        Alert a = new Alert(Alert.AlertType.ERROR);
        a.setTitle("Error");
        a.setHeaderText(title);
        a.setContentText(ex.getMessage());
        a.showAndWait();
    }

    private void showInfo(String title, String msg) {
        Alert a = new Alert(Alert.AlertType.INFORMATION);
        a.setTitle("Info");
        a.setHeaderText(title);
        a.setContentText(msg);
        a.showAndWait();
    }
}
