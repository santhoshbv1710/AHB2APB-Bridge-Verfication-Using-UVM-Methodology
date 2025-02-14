class ahb_monitor extends uvm_monitor;
	
	`uvm_component_utils(ahb_monitor)
	
	uvm_analysis_port #(ahb_xtn) monitor_port;
	virtual ahb_if.AHB_MON vif;
	ahb_config cfg;
	function new(string name = "ahb_monitor",uvm_component parent);
		super.new(name,parent);
				monitor_port = new("monitor port",this);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(ahb_config) :: get(this,"","ahb_config",cfg))
			`uvm_fatal("AHB_DRV","Getting Failed !!!")
	endfunction

	function void connect_phase(uvm_phase phase);
		vif = cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
	forever
		collect_data();
	endtask

	task collect_data();
		ahb_xtn xtn;
		xtn = ahb_xtn :: type_id :: create("hxtn");
	//	$display("out = %0d",vif.ahb_mon_cb.Htrans);
		
		while(vif.ahb_mon_cb.Htrans<=1)
			@(vif.ahb_mon_cb);
	
		xtn.Hwrite = vif.ahb_mon_cb.Hwrite; 
		xtn.Htrans = vif.ahb_mon_cb.Htrans;
		xtn.Haddr = vif.ahb_mon_cb.Haddr;
		xtn.Hsize = vif.ahb_mon_cb.Hsize;
		xtn.Hburst = vif.ahb_mon_cb.Hburst;

		@(vif.ahb_mon_cb);

		while(!vif.ahb_mon_cb.Hreadyout)
			@(vif.ahb_mon_cb);

		if(xtn.Hwrite)
			xtn.Hwdata = vif.ahb_mon_cb.Hwdata;
		else
			xtn.Hrdata = vif.ahb_mon_cb.Hrdata;
	
		`uvm_info("AHB_MON",$sformatf("Printing from ahb monitor \n %s",xtn.sprint()),UVM_LOW)

		monitor_port.write(xtn);


	endtask

endclass
