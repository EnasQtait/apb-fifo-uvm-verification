class my_scoreboard extends uvm_component;
  `uvm_component_utils(my_scoreboard)

  uvm_analysis_imp #(transaction, my_scoreboard) imp;

  byte fifo[$];
  int DEPTH = 16;
  bit en;

  function new(string name, uvm_component parent);
    super.new(name,parent);
    imp = new("imp",this);
  endfunction

  function void write(transaction tr);

    // CTRL
    if (tr.addr == 8'h00 && tr.write) begin
      en = tr.wdata[0];
      if (tr.wdata[1]) fifo.delete();
    end

    // DATA
    if (tr.addr == 8'h0C && en) begin
      if (tr.write) begin
        if (fifo.size() < DEPTH)
          fifo.push_back(tr.wdata[7:0]);
        else
          `uvm_warning("SB","Expected overflow")
      end
      else begin
        if (fifo.size() > 0) begin
          byte exp = fifo.pop_front();
          if (exp !== tr.rdata[7:0])
            `uvm_error("SB","DATA MISMATCH")
        end
        else
          `uvm_warning("SB","Expected underflow")
      end
    end
  endfunction
endclass
