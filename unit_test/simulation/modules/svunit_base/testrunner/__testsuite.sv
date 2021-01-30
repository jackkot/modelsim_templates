module __testsuite;
  import svunit_pkg::svunit_testsuite;

  string name = "__ts";
  svunit_testsuite svunit_ts;
  
  
  //===================================
  // These are the unit tests that we
  // want included in this testsuite
  //===================================
  dut_unit_test dut_ut();


  //===================================
  // Build
  //===================================
  function void build();
    dut_ut.build();
    svunit_ts = new(name);
    svunit_ts.add_testcase(dut_ut.svunit_ut);
  endfunction


  //===================================
  // Run
  //===================================
  task run();
    svunit_ts.run();
    dut_ut.run();
    svunit_ts.report();
  endtask

endmodule
