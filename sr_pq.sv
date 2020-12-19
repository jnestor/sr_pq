// Shift-register version of the priority queue
//
//

module #(parameter kW=8, VW=4) sr_pq(
  input logic clk, rst, push, pop,
  input logic [KW+VW-1:0] kvi,
  output logic [KW+VW-1:0] kvo,  // lowest element in queue
  output logic full, empty
  );

   logic [0:DEPTH+1] k_lt_ki_v;
   logic [0:DEPTH+1][KV+VW-1:0] kv_v;

   assign k_lt_ki_v[0] = 0;
   assign k_lt_ki_v[DEPTH+1] = 1;
   assign kv_v[0] = kvi;
   assign kv_v[DEPTH+1] = { KEYINF, VAL0 };
   assign kvo = kv_v[1];

   assign empty = (kv_v[0][KV+VW-1:VW] == KEYINF);
   assign full = (kv_v[DEPTH][KV+VW-1:VW] != KEYINF)

   genvar i;
   generate for (i=1; i<=DEPTH; i++) begin
       sr_pq_stage(
          .clk, .rst, .push, .pop,
          .kprev_lt_ki(k_lt_ki_v[i-1]), .knext_lt_ki(k_lt_ki_v[i-1])),
          .kvi(kvi), .kvprev(kv_v[i-1]), .kvnext(kv_v[i+1]),
          .k_lt_ki(k_lt_ki_v[i])
       );
    end

endmodule: sr_pq
