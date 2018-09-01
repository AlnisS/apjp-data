import java.util.Map;

println("starting...");

Table table = loadTable("../data.csv", "header");
HashMap<String, Table> outs = new HashMap<String, Table>();

println("data loaded...\nprocessing data...");

for (TableRow row : table.rows()) {
  String name = row.getString("unit") + (row.getString("b").equals("y") ? "-bonus" : "");
  Table ne;
  Table ke;
  Table kn;
  
  if (!outs.containsKey(name + "_kana-english")) {
    ne = new Table();
    ke = new Table();
    kn = new Table();
    
    ne.addColumn("kana");  ne.addColumn("english");
    ke.addColumn("kanji"); ke.addColumn("english");
    kn.addColumn("kanji"); kn.addColumn("kana");
    
    outs.put(name + "_kana-english", ne);
    outs.put(name + "_kanji-english", ke);
    outs.put(name + "_kanji-kana", kn);
  } else {
    ne = outs.get(name + "_kana-english");
    ke = outs.get(name + "_kanji-english");
    kn = outs.get(name + "_kanji-kana");
  }
  
  TableRow ne_row = ne.addRow();
  ne_row.setString("kana",    row.getString("kana"));
  ne_row.setString("english", row.getString("english"));
  
  if (!row.getString("kanji").equals("-")) {
    TableRow ke_row = ke.addRow();
    TableRow kn_row = kn.addRow();
    ke_row.setString("kanji",   row.getString("kanji"));
    ke_row.setString("english", row.getString("english"));
    kn_row.setString("kanji",   row.getString("kanji"));
    kn_row.setString("kana",    row.getString("kana"));
  }
}

println("saving data...");

for (Map.Entry<String, Table> entry : outs.entrySet()) {
  String name = entry.getKey();
  Table tosave = entry.getValue();
  String unit = name.substring(0, name.indexOf("_"));
  saveTable(tosave, "../units/" + unit + "/" + name + ".csv");
}

println("done!");

exit();
