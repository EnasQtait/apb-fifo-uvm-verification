class basic_sequence extends uvm_sequence #(transaction);
  `uvm_object_utils(basic_sequence)

  function new(string name="basic_sequence");
    super.new(name);
  endfunction

  task body();
    transaction tr;

    tr = transaction::type_id::create("tr");
    start_item(tr);
    assert(tr.randomize());
    finish_item(tr);
  endtask
endclass
