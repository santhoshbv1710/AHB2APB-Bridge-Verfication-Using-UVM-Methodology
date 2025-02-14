class ahb_seqs extends uvm_sequence #(ahb_xtn);

	`uvm_object_utils(ahb_seqs)

	function new(string name = "ahb_seqs");
		super.new(name);
	endfunction

	bit [31:0] haddr;
	bit hwrite;
	bit [2:0] hsize;
	bit [2:0] hburst;
endclass

class single_seqs extends ahb_seqs;
	
	`uvm_object_utils(single_seqs)

	function new(string name = "single_seqs");
		super.new(name);
	endfunction

	task body();
		repeat(1)begin
				req = ahb_xtn :: type_id :: create("req");
				start_item(req);
				assert(req.randomize() with {Htrans == 2 && Hburst == 0;}); //Non_sequential && Single transfer
				finish_item(req);
			end
	//	#30;
	endtask
endclass


class burst_seqs extends ahb_seqs;  //sequential

	`uvm_object_utils(burst_seqs)

	function new(string name = "burst_seqs");
		super.new(name);
	endfunction
	
	task body();
		repeat(1)begin
				
				req = ahb_xtn :: type_id :: create("req");
				start_item(req);
				assert(req.randomize() with {Htrans == 2 && Hburst inside {[1:7]};});
				finish_item(req);
				
				haddr = req.Haddr;
				hwrite = req.Hwrite;
				hsize = req.Hsize;
				hburst = req.Hburst;

		//Unspecified  Length or (4 or 8 or 16) beat incrementing
	
			if(hburst == 1 || hburst == 3 || hburst == 5 || hburst == 7)begin					
				for(int i=0;i<req.length-1;i++)begin
					start_item(req);

					assert(req.randomize() with{Haddr == haddr+(2**hsize);Hwrite==hwrite;Hsize==hsize;Hburst==hburst;Htrans==3;});	
		
					finish_item(req);

						haddr = req.Haddr;
					end
				end

		//4-beat wrapping burst

	if(hburst == 2)begin					
			for(int i=0;i<req.length-1;i++)begin
				start_item(req);

		if(hsize == 0)
			assert(req.randomize() with{Haddr == {haddr[31:2],haddr[1:0]+1'b1};Hwrite==hwrite;Hsize==hsize;Hburst==hburst;Htrans==3;});

		if(hsize == 1)
			assert(req.randomize() with{Haddr == {haddr[31:3],haddr[2:1]+1'b1,haddr[0]};Hwrite==hwrite;Hsize==hsize;Hburst==hburst;Htrans==3;});

		if(hsize == 2 )
			assert(req.randomize() with{Haddr == {haddr[31:4],haddr[3:2]+1'b1,haddr[1:0]};Hwrite==hwrite;Hsize==hsize;Hburst==hburst;Htrans==3;});

				finish_item(req);

						haddr = req.Haddr;
					end
				end

		// 8-beat wrapping

	if(hburst == 4)begin					
		for(int i=0;i<req.length-1;i++)begin
				start_item(req);

		if(hsize == 0)
			assert(req.randomize() with{Haddr == {haddr[31:3],haddr[2:0]+1'b1};Hwrite==hwrite;Hsize==hsize;Hburst==hburst;Htrans==3;});

		if(hsize == 1)
			assert(req.randomize() with{Haddr == {haddr[31:4],haddr[3:1]+1'b1,haddr[0]};Hwrite==hwrite;Hsize==hsize;Hburst==hburst;Htrans==3;});

		if(hsize == 2 )
			assert(req.randomize() with{Haddr == {haddr[31:5],haddr[4:2]+1'b1,haddr[1:0]};Hwrite==hwrite;Hsize==hsize;Hburst==hburst;Htrans==3;});

				finish_item(req);

						haddr = req.Haddr;
					end
				end

		// 16 - beat wrapping

	if(hburst == 6)begin					
		for(int i=0;i<req.length-1;i++)begin
				start_item(req);
		if(hsize == 0)
			assert(req.randomize() with{Haddr == {haddr[31:4],haddr[3:0]+1'b1};Hwrite==hwrite;Hsize==hsize;Hburst==hburst;Htrans==3;});

		if(hsize == 1)
			assert(req.randomize() with{Haddr == {haddr[31:5],haddr[4:1]+1'b1,haddr[0]};Hwrite==hwrite;Hsize==hsize;Hburst==hburst;Htrans==3;});

		if(hsize == 2 )
			assert(req.randomize() with{Haddr == {haddr[31:6],haddr[5:2]+1'b1,haddr[1:0]};Hwrite==hwrite;Hsize==hsize;Hburst==hburst;Htrans==3;});

				finish_item(req);

						haddr = req.Haddr;
					end
				end
			end
	//	#30;
	endtask

endclass


