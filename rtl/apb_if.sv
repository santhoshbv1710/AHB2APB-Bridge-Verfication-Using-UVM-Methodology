interface apb_if (input bit clk);

	bit Penable;
	bit Pwrite;
	
	logic [31:0] Pwdata;
	logic [31:0] Prdata;
	logic [31:0] Paddr;
	bit [3:0] Pselx;
	bit a;
	
	clocking apb_drv_cb @(posedge clk);
	default input #1 output #1;

		output Prdata;
		output a;
		input Penable;
		input Pwrite;
		input Pselx;
	endclocking

	clocking apb_mon_cb @(posedge clk);
	default input #1 output #1;

		input Prdata;
		input Penable;
		input Pwrite;
		input Pselx;
		input Paddr;
		input Pwdata;
		input a;
	endclocking

	modport APB_DRV (clocking apb_drv_cb);
	modport APB_MON (clocking apb_mon_cb);

endinterface
