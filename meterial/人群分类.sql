1.模拟数据
	Subject 1
	券敏感型/actType[5]												
		券核销率:Double/%	核销次数 Int	核销距离平均时长 Double		最后一次核销时间	天/Int
		
		
		Subject 2
	积分敏感型/actType[]
		完善资料得分[6] Int 		游戏得分[7] Int		积分兑券[1] Int		积分兑礼[8]  Int	
	
		Subject 3
	互动意愿/actType[]
		大转盘[4] Int  	砸金蛋[3] Int   刮刮卡[2] Int	完善资料[9] Int		预约次数[10] Int	
		到店次数[11] Int  	领券次数[12] Int   领红包次数[13] Int	分享次数[14] Int	 	打开次数[15] Int	
		联系导购[16] Int    订单评价[17] Int	
	
		
2.主题内Kmeans聚类
	o.数据探索,对每一类数据,通过 均值、最值、中位数、众数进行分析
	o.针对分析结果,确定行为特征,比如: [0,1,2]三类, 0,1,2类中券核销率均值 依次下降, 核销距离平均时长均值 依次增大, 可视敏感度程度排序为 0>1>2
	o.依据特征分析结果,进行权重评估,比如 [0,1,2]:=[50%,30%, 20%]

3.和业务沟通, 确认权重合理性

4.打分

5.分数、人数柱状图	
			人数|
				|  | 
				|  |	|
				|  |    |   |
				- - - - - - -
						分数

6.权重预测
	行为 * 权重 = 分数  => 权重
	
	
 英雄联盟打手	KDA	
     [击杀  死亡  助攻]  = (K + A)/D
							(13 + 15)/8 = 3.5
							   
 NBA球员效率指数
   由ESPN专家约翰·霍林格提出的球员价值评估数据体系。利用PER值，可以将球员所有表现记录下来，然后加权集成，综合而成，便可以对不同位置、不同年代的球员进行评估和比较。
	其计算公式为：
  [(得分数+助攻数+总篮板数+抢断数+盖帽数)-(投篮出手数-投篮命中数)-(罚球出手数-罚球命中数)-失误数]/球员的比赛场次。
  场数	先发	场均篮板	场均助攻	分钟	效率	%		三分%	罚球%	进攻	防守	场均抢断	场均盖帽	失误	犯规	场均得分	
  2		2			5		2.5			26.5	23.5	53.6	46.7	100.0	0		 5		 1				0.5		2.5		 1		 23.5	

  券敏感型  
	计算公式 
		得分 = 券核销率 + 核销次数  - 核销距离平均时长 - 最后一次核销时间
		得分 = (券核销率 + 核销次数) / 核销距离平均时长 - 最后一次核销时间
  券核销率 %		核销次数 		核销距离平均时长/Double 		最后一次核销时间 天/Int 
1.	80					27				 	15.5					30		
	score = 80 + 27 - 15.5 - 30	= 61.5
	
2.	70					13				 	55.5					-1  	针对-1的情况  -1 -> 0
	score = 70 + 13 - 55.5 - 0	= 27.5
	
	
	A	 					B						C	 											D
	券核销率			券核销次数			核销距离平均时长								最后一次核销时间
	
	核销券数								SUM(核销券核销时间 - 核销券的取券时间)
   ------------			核销券数		 ------------------------------------------			最后一次核销时间/天	
	全部券数											核销券数
  	
	
	打分公式	score = A * C * B / D 
	
	核销券数		SUM(核销券核销时间 - 核销券的取券时间)
   ----------- * ------------------------------------------	* 核销券数
	全部券数				  核销券数 * 最后一次核销时间
	
	
			核销券数		SUM(核销券核销时间 - 核销券的取券时间)    		SUM(核销券核销时间 - 核销券的取券时间)  
	得分 = ----------- * [------------------------------------------  +   ------------------------------------------]/B
			全部券数				  最后一次核销时间								最后一次核销时间
			
			
	打分公式   score = A * 100  +  B  -   C  -	D 		
			核销券数		SUM(核销券核销时间 - 核销券的取券时间)    		SUM(核销券核销时间 - 核销券的取券时间)  
	得分 = ----------- * [------------------------------------------  +   ------------------------------------------]/B
			全部券数				  最后一次核销时间								最后一次核销时间
	
	雷达图计算面积  S = (A + B) * (1/C + 1/D)/2 
	打分公式
	score = 2S 
	