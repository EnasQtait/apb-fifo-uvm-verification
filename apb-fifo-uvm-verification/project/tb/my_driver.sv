class my_driver extends uvm_driver #(transaction);
  `uvm_component_utils(my_driver)

  virtual apb_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db #(virtual apb_if)::get(this,"","vif",vif))
      `uvm_fatal("DRV","No apb_if")
  endfunction

  task run_phase(uvm_phase phase);
    transaction tr;

    vif.PSEL    <= 0;
    vif.PENABLE <= 0;
    vif.PWRITE  <= 0;
    vif.PADDR   <= 0;
    vif.PWDATA  <= 0;

    forever begin
      seq_item_port.get_next_item(tr);

      @(posedge vif.PCLK);
      vif.PSEL   <= 1;
      vif.PWRITE <= tr.write;
      vif.PADDR  <= tr.addr;
      vif.PWDATA <= tr.wdata;
      vif.PENABLE<= 0;

      @(posedge vif.PCLK);
      vif.PENABLE <= 1;

      @(posedge vif.PCLK);
      tr.rdata = vif.PRDATA;
      vif.PSEL <= 0;
      vif.PENABLE <= 0;

      seq_item_port.item_done();
    end
  endtask
endclass
