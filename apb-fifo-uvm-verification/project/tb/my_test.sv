class my_test extends uvm_test;
  `uvm_component_utils(my_test)

  my_env env;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    env = my_env::type_id::create("env", this);
  endfunction

 task run_phase(uvm_phase phase);
  fifo_directed_test_seq dir_seq;
  fifo_random_seq        rnd_seq;

  phase.raise_objection(this);

  env.agent.drv.vif.PRESETn = 0;
  #20;
  env.agent.drv.vif.PRESETn = 1;

  dir_seq = fifo_directed_test_seq::type_id::create("dir_seq");
  dir_seq.start(env.agent.seqr);

  rnd_seq = fifo_random_seq::type_id::create("rnd_seq");
  rnd_seq.start(env.agent.seqr);

  #500;
  phase.drop_objection(this);
endtask


endclass
