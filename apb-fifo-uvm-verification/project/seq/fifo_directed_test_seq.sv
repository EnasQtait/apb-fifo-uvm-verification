localparam CTRL_O = 8'h00;
localparam DATA_O = 8'h0C;

class fifo_directed_test_seq extends uvm_sequence #(transaction);
  `uvm_object_utils(fifo_directed_test_seq)

  function new(string name="fifo_directed_test_seq");
    super.new(name);
  endfunction

  task body();
    transaction tr;

    // EN = 1
    tr = transaction::type_id::create("tr");
    start_item(tr);
    tr.write = 1;
    tr.addr  = CTRL_O;
    tr.wdata = 32'b1;
    finish_item(tr);

    // Fill FIFO
    repeat (16) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      tr.write = 1;
      tr.addr  = DATA_O;
      tr.wdata = $urandom_range(0,255);
      finish_item(tr);
    end

    // Overflow
    tr = transaction::type_id::create("tr");
    start_item(tr);
    tr.write = 1;
    tr.addr  = DATA_O;
    tr.wdata = 8'hFF;
    finish_item(tr);

    // Empty FIFO
    repeat (16) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      tr.write = 0;
      tr.addr  = DATA_O;
      finish_item(tr);
    end

    // Underflow
    tr = transaction::type_id::create("tr");
    start_item(tr);
    tr.write = 0;
    tr.addr  = DATA_O;
    finish_item(tr);
  endtask
endclass
