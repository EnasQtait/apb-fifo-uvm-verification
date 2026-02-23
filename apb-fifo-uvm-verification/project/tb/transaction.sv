class transaction extends uvm_sequence_item;
  `uvm_object_utils(transaction)

  rand bit        write;
  rand bit [7:0]  addr;
  rand bit [31:0] wdata;
       bit [31:0] rdata;

  function new(string name="transaction");
    super.new(name);
  endfunction
endclass
