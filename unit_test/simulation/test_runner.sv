module __testsuite;
  import svunit_pkg::svunit_testsuite;

  string name = "__ts";
  svunit_testsuite svunit_ts;
  
  
  //===================================
  // These are the unit tests that we
  // want included in this testsuite
  //===================================
  testbench_unit_test testbench_ut();
  // xxx_unit_test xxx_ut();

  //===================================
  // Build
  //===================================
  function void build();
    svunit_ts = new(name);
    
    testbench_ut.build();
    svunit_ts.add_testcase(testbench_ut.svunit_ut);
    
    // xxx_ut.build();
    // svunit_ts.add_testcase(xxx_ut.svunit_ut);

  endfunction


  //===================================
  // Run
  //===================================
  task run();
    svunit_ts.run();

    testbench_ut.run();
    // xxx_ut.run();

    svunit_ts.report();
    $stop();
  endtask

endmodule
