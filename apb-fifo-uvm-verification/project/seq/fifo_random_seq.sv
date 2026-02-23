class fifo_random_seq extends uvm_sequence #(transaction);
  `uvm_object_utils(fifo_random_seq)

  function new(string name="fifo_random_seq");
    super.new(name);
  endfunction

  task body();
    transaction tr;
    repeat (50) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      tr.write = $urandom_range(0,1);
      tr.addr  = ($urandom_range(0,1)) ? 8'h0C : 8'h00;
      tr.wdata = $urandom;
      finish_item(tr);
    end
  endtask
endclass
