class scoreboard extends uvm_scoreboard;

	`uvm_component_utils(scoreboard)


	uvm_tlm_analysis_fifo #(ahb_xtn) hm;
	uvm_tlm_analysis_fifo #(apb_xtn) pm[];

	ahb_xtn ahb_data;
	apb_xtn apb_data;


	static int apb_count=0;
	static int ahb_count = 0;

	static int compared = 0;
	static int drop = 0;

	function new(string name = "scoreboard",uvm_component parent);
		super.new(name,parent);
		pm = new[1];
		hm = new("hmport",this);
		pm[0] = new("pmport[0]",this);
	endfunction


	task run_phase(uvm_phase phase);
		forever
			begin
				fork
					begin
						hm.get(ahb_data);
						ahb_count++;
					end

					begin
						pm[0].get(apb_data);
						apb_count++;
					end
				join
					check_data();
				
			end
	endtask
	
	task compare_data(int Haddr,Paddr,Hdata,Pdata);
		`uvm_info("SB",$sformatf("From Scoreboard : AHB Data \n %s",ahb_data.sprint()),UVM_LOW)
		`uvm_info("SB",$sformatf("From Scoreboard : APB Data \n %s",apb_data.sprint()),UVM_LOW)
		if(Haddr == Paddr && Hdata == Pdata)begin
			`uvm_info("SB_Data_Matched","Data matched",UVM_LOW)
			compared++;
		end
		else
			begin
		`uvm_info("SB_Data_Mismatched",$sformatf("Data Mismatch \n Paddr = %0h , Haddr = %0h  , Hdata = %0h , Pdata = %0h",Paddr,Haddr,Hdata,Pdata),UVM_LOW)
			drop++;
			end
		
	endtask
	task check_data();
		
		if(ahb_data.Hwrite)begin
			case(ahb_data.Hsize)

				2'b00 :
					begin
						if(ahb_data.Haddr[1:0] == 2'b00)
								compare_data(ahb_data.Haddr,apb_data.Paddr,ahb_data.Hwdata[7:0],apb_data.Pwdata[7:0]);
						if(ahb_data.Haddr[1:0] == 2'b01)
								compare_data(ahb_data.Haddr,apb_data.Paddr,ahb_data.Hwdata[15:8],apb_data.Pwdata[7:0]);
						if(ahb_data.Haddr[1:0] == 2'b10)
								compare_data(ahb_data.Haddr,apb_data.Paddr,ahb_data.Hwdata[23:16],apb_data.Pwdata[7:0]);
						if(ahb_data.Haddr[1:0] == 2'b11)
								compare_data(ahb_data.Haddr,apb_data.Paddr,ahb_data.Hwdata[31:24],apb_data.Pwdata[7:0]);
					end

				2'b01 :
					begin
						if(ahb_data.Haddr[1:0] == 2'b00)
								compare_data(ahb_data.Haddr,apb_data.Paddr,ahb_data.Hwdata[15:0],apb_data.Pwdata[15:0]);
						if(ahb_data.Haddr[1:0] == 2'b10)
								compare_data(ahb_data.Haddr,apb_data.Paddr,ahb_data.Hwdata[31:16],apb_data.Pwdata[15:0]);
					end

				2'b10 :
						compare_data(ahb_data.Haddr,apb_data.Paddr,ahb_data.Hwdata,apb_data.Pwdata);

			endcase
		end

		else
			begin

				case(ahb_data.Hsize)

				2'b00 :
					begin
						if(ahb_data.Haddr[1:0] == 2'b00)
								compare_data(ahb_data.Haddr,apb_data.Paddr,ahb_data.Hrdata[7:0],apb_data.Prdata[7:0]);
						if(ahb_data.Haddr[1:0] == 2'b01)
								compare_data(ahb_data.Haddr,apb_data.Paddr,ahb_data.Hrdata[7:0],apb_data.Prdata[15:8]);
						if(ahb_data.Haddr[1:0] == 2'b10)
								compare_data(ahb_data.Haddr,apb_data.Paddr,ahb_data.Hrdata[7:0],apb_data.Prdata[23:16]);
						if(ahb_data.Haddr[1:0] == 2'b11)
								compare_data(ahb_data.Haddr,apb_data.Paddr,ahb_data.Hrdata[7:0],apb_data.Prdata[31:24]);
					end

				2'b01 :
					begin
						if(ahb_data.Haddr[1:0] == 2'b00)
								compare_data(ahb_data.Haddr,apb_data.Paddr,ahb_data.Hrdata[15:0],apb_data.Prdata[15:0]);
						if(ahb_data.Haddr[1:0] == 2'b10)
								compare_data(ahb_data.Haddr,apb_data.Paddr,ahb_data.Hrdata[15:0],apb_data.Prdata[31:16]);
					end

				2'b10 :
						compare_data(ahb_data.Haddr,apb_data.Paddr,ahb_data.Hrdata,apb_data.Prdata);

			endcase
		end
	endtask



	function void report_phase(uvm_phase phase);
	`uvm_info("SB",$sformatf("\n Total AHB Received : %0d , Total APB Received = %0d , \n Data compared : %0d , Data Dropped : %0d",ahb_count,apb_count,compared,drop),UVM_LOW)
	endfunction		
					

endclass

	
