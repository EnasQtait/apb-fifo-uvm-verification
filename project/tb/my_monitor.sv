class my_monitor extends uvm_monitor;
  `uvm_component_utils(my_monitor)

  uvm_analysis_port #(transaction) ap;
  virtual apb_if vif;

  // ===============================
  // ===============================
  covergroup fifo_cg;
    option.per_instance = 1;

    coverpoint write {
      bins WRITE = {1};
      bins READ  = {0};
    }

    coverpoint addr {
      bins CTRL = {8'h00};
      bins DATA = {8'h0C};
    }

    cross write, addr;
  endgroup

  // signals used by coverage
  bit       write;
  bit [7:0] addr;

  function new(string name, uvm_component parent);
    super.new(name,parent);
    ap = new("ap",this);
    fifo_cg = new();   // ✅ صحيح الآن
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db #(virtual apb_if)::get(this,"","vif",vif))
      `uvm_fatal("MON","No apb_if")
  endfunction

  task run_phase(uvm_phase phase);
    transaction tr;
    forever begin
      @(posedge vif.PCLK);
      if (vif.PSEL && vif.PENABLE) begin
        tr = transaction::type_id::create("tr");
        tr.write = vif.PWRITE;
        tr.addr  = vif.PADDR;
        tr.wdata = vif.PWDATA;
        tr.rdata = vif.PRDATA;

        write = tr.write;
        addr  = tr.addr;

        fifo_cg.sample();   
        ap.write(tr);
      end
    end
  endtask
endclass
