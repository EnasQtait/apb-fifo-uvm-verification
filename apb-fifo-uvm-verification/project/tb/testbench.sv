`timescale 1ns/1ns

`include "apb_if.sv"
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "transaction.sv"
`include "my_sequencer.sv"
`include "my_driver.sv"
`include "my_monitor.sv"
`include "uvm_scoreboard.sv"
`include "my_agent.sv"
`include "my_env.sv"
`include "fifo_directed_test_seq.sv"
`include "fifo_random_seq.sv"
`include "my_test.sv"

module tb_top;

  logic PCLK = 0;
  always #5 PCLK = ~PCLK;

  apb_if vif(PCLK);

  apb_sync_fifo dut (
    .PCLK    (PCLK),
    .PRESETn (vif.PRESETn),
    .PSEL    (vif.PSEL),
    .PENABLE (vif.PENABLE),
    .PWRITE  (vif.PWRITE),
    .PADDR   (vif.PADDR),
    .PWDATA  (vif.PWDATA),
    .PRDATA  (vif.PRDATA),
    .PREADY  (vif.PREADY),
    .PSLVERR (vif.PSLVERR)
  );

  initial begin
    vif.PRESETn = 0;
  end

  initial begin
    uvm_config_db #(virtual apb_if)::set(null,"*","vif",vif);
    run_test("my_test");
  end

endmodule
