class my_env extends uvm_env;
  `uvm_component_utils(my_env)

  my_agent      agent;
  my_scoreboard sb;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    agent = my_agent     ::type_id::create("agent", this);
    sb    = my_scoreboard::type_id::create("sb", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    agent.mon.ap.connect(sb.imp);
  endfunction
endclass
