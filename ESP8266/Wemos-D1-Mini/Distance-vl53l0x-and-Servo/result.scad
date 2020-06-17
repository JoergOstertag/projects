segment(i=0	,d=52.10);
segment(i=10	,d=50.90);
segment(i=12	,d=51.50);
segment(i=14	,d=51.70);
segment(i=16	,d=53.10);
segment(i=18	,d=56.90);
segment(i=20	,d=57.20);
segment(i=22	,d=61.00);
segment(i=24	,d=63.40);
segment(i=26	,d=63.30);
segment(i=28	,d=62.10);
segment(i=30	,d=62.80);
segment(i=32	,d=63.30);
segment(i=34	,d=63.30);
segment(i=36	,d=62.60);
segment(i=38	,d=64.20);
segment(i=40	,d=63.70);
segment(i=42	,d=65.00);
segment(i=44	,d=65.30);
segment(i=46	,d=66.50);
segment(i=48	,d=67.40);
segment(i=50	,d=67.60);
segment(i=52	,d=70.80);
segment(i=54	,d=71.80);
segment(i=56	,d=72.00);
segment(i=58	,d=76.00);
segment(i=60	,d=76.90);
segment(i=62	,d=80.10);
segment(i=64	,d=819.10);
segment(i=66	,d=819.10);
segment(i=68	,d=819.10);
segment(i=70	,d=819.10);
segment(i=72	,d=819.10);
segment(i=74	,d=819.10);
segment(i=76	,d=819.10);
segment(i=78	,d=819.10);
segment(i=80	,d=819.10);
segment(i=82	,d=819.10);
segment(i=84	,d=819.10);
segment(i=86	,d=819.10);
segment(i=88	,d=819.10);
segment(i=90	,d=819.10);
segment(i=92	,d=819.10);
segment(i=94	,d=120.00);
segment(i=96	,d=120.10);
segment(i=98	,d=117.50);
segment(i=100	,d=119.30);
segment(i=102	,d=118.20);
segment(i=104	,d=116.10);
segment(i=106	,d=114.70);
segment(i=108	,d=116.20);
segment(i=110	,d=113.80);
segment(i=112	,d=112.80);
segment(i=114	,d=103.00);
segment(i=116	,d=89.30);
segment(i=118	,d=69.00);
segment(i=120	,d=58.50);
segment(i=122	,d=49.30);
segment(i=124	,d=45.80);
segment(i=126	,d=42.80);
segment(i=128	,d=41.40);
segment(i=130	,d=40.40);
segment(i=132	,d=39.60);
segment(i=134	,d=38.70);
segment(i=136	,d=38.40);
segment(i=138	,d=37.90);
segment(i=140	,d=38.10);
segment(i=142	,d=37.70);
segment(i=144	,d=37.60);
segment(i=146	,d=37.40);
segment(i=148	,d=37.60);
segment(i=150	,d=38.10);
segment(i=152	,d=38.20);
segment(i=150	,d=37.80);
segment(i=148	,d=37.80);
segment(i=146	,d=33.60);
segment(i=144	,d=-1);





module segment(i=0,d=20){
	if ( d < 0) {
		outOfRange(i=i);
	}else {
		rotate([0,90,i]) cylinder(d1=1,d2=0.4226*d,h=d);
	}
}
	
module outOfRange(i=0){
	color("red")
		rotate([0,90,i]) cylinder(d1=1,d2=1,h=1200);
}