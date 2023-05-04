proc fcmp outlib=work.sas_functions.dateFunctions;

	function ehFeriado(Data);
		ano 			      = year(Data);
		confrUniversal 	= input("0101"||put(ano,z4.),ddmmyy10.);
		tiradentes 		  = input("2104"||put(ano,z4.),ddmmyy10.);
		diaTrabalho 	  = input("0105"||put(ano,z4.),ddmmyy10.);
		independencia 	= input("0709"||put(ano,z4.),ddmmyy10.);
		nsraAparecida 	= input("1210"||put(ano,z4.),ddmmyy10.);
		finados 		    = input("0211"||put(ano,z4.),ddmmyy10.);
		republica 		  = input("1511"||put(ano,z4.),ddmmyy10.);
		natal 		      = input("2512"||put(ano,z4.),ddmmyy10.);
		pascoa 		      = HOLIDAY('EASTER', ano);
		segCarnaval 	  = pascoa - 48;
		terCarnaval 	  = pascoa - 47;
		sextaPaixao 	  = pascoa - 2;
		corpusChristi 	= pascoa + 60;

		if Data in (confrUniversal, segCarnaval, terCarnaval, sextaPaixao, pascoa, corpusChristi, tiradentes, diaTrabalho, independencia, nsraAparecida, finados, republica, natal) then
			return(1);
		else return(0);
	endsub;

	function ehDiaUtil(Data);
		if weekday(Data) in (1, 7) or ehFeriado(Data) = 1 then
			return(0);
		else return(1);
	endsub;

	function diaUtilAnterior(Data);
		diaAnterior = intnx('day',Data,-1);
		do while (ehDiaUtil(diaAnterior) = 0);
			diaAnterior = intnx('day', diaAnterior, -1);
		end;
		return(diaAnterior);
	endsub;

	function diaUtilPosterior(Data);
		diaPosterior = intnx('day',Data,1);
		do while (ehDiaUtil(diaPosterior) = 0);
			diaPosterior = intnx('day', diaPosterior, 1);
		end;
		return(diaPosterior);
	endsub;

	function diaAnterior(Data);
		diaAnterior = intnx('day',Data,-1);
		return(diaAnterior);
	endsub;

	function diaPosterior(Data);
		diaPosterior = intnx('day',Data,1);
		return(diaPosterior);
	endsub;

	function seDiaNaoUtilPosteriorUtil(Data);
		if ehDiaUtil(Data) = 0 then
			return(diaUtilPosterior(Data));
		else return(Data);
	endsub;

	function seDiaNaoUtilAnteriorUtil(Data);
		if ehDiaUtil(Data) = 0 then
			return(diaUtilAnterior(Data));
		else return(Data);
	endsub;

	function qntDiasUteisEntreDatas(DataInicio, DataFim);
		QntDias = 0;
		AddData = DataInicio;
		if DataInicio <= DataFim then;
		do while (AddData <= DataFim);
			if ehDiaUtil(AddData) <> 0 then
				QntDias = QntDias + 1;
			AddData = intnx('day',AddData,1);
		end;
		return(QntDias);
	endsub;

	function retornaDiaUtil(data, qtdeDias);
		qtdeDiasUteis = 0;
		dataRef = data;
		do while (qtdeDiasUteis < abs(qtdeDias));
			if qtdeDias > 0 then
				dataRef = dataRef + 1;
			else
				dataRef = dataRef - 1;

			if ehDiaUtil(dataRef) then
				qtdeDiasUteis = qtdeDiasUteis + 1;
		end;
		return(dataRef);
	endsub;

	function setDiaUtilAnterior(Data, Dias);
		diaAnterior = retornaDiaUtil(Data, (0 - Dias));
		return(diaAnterior);
	endsub;

	function setDiaUtilPosterior(Data, Dias);
		diaPosterior = retornaDiaUtil(Data, Dias);
		return(diaPosterior);
	endsub;

	function primeiroDiaMes(Data);
		primeiroDiaMesData = intnx('month',Data,0);
		return(primeiroDiaMesData);
	endsub;

	function ultimoDiaMes(Data);
		proximoMes= intnx('month',Data,1);
		primeiroDiaProximoMes = primeiroDiaMes(proximoMes);
		ultimoDiaMes = intnx('day',primeiroDiaProximoMes,-1);
		return(ultimoDiaMes);
	endsub;

	function primeiroDiaUtilMes(Data);
		primeiroDiaMesData = intnx('month',Data,0);
		if ehDiaUtil(primeiroDiaMesData) = 0 then
			return(diaUtilPosterior(primeiroDiaMesData));
		else return(primeiroDiaMesData);
	endsub;

	function ultimoDiaUtilMes(Data);
		primeiroDiaProximoMes= intnx('month',Data,1);
		ultimoDiaUtilMesData = diaUtilAnterior(primeiroDiaProximoMes);
		return(ultimoDiaUtilMesData);
	endsub;

	function sextaAnterior(Data);
		diaAnterior = intnx('day',Data,-1);
		do while (weekday(diaAnterior) not in (6));
			diaAnterior = intnx('day', diaAnterior, -1);
		end;
		return(diaAnterior);
	endsub;

	function primeiraSextaMes(Data);
		primeiroDiaMesData = intnx('month',Data,0);
		do while (weekday(primeiroDiaMesData) not in (6));
			primeiroDiaMesData = intnx('day', primeiroDiaMesData, 1);
		end;
		return(primeiroDiaMesData);
	endsub;

	function semestre(Data);
		if MONTH(Data) in (1, 2, 3, 4, 5, 6) then
			return(1);
		else return(2);
	endsub;

	function primeiroDiaSemestre(Data);
		if semestre(Data) in (1) then
			return(MDY(01,01,YEAR(Data)));
		else return(MDY(07,01,YEAR(Data)));
	endsub;

	function ultimoDiaSemestre(Data);
		if semestre(Data) in (1) then
			return(MDY(06,30,YEAR(Data)));
		else return(MDY(12,31,YEAR(Data)));
	endsub;

	function primeiroMesSemestre(semestre);
		if semestre in (1) then
			return(1);
		else return(7);
	endsub;

	function ultimoMesSemestre(semestre);
		if semestre in (1) then
			return(6);
		else return(12);
	endsub;

	function trimestre(Data);
		if MONTH(Data) in (1, 2, 3) then
			return(1);
		else if MONTH(Data) in (4, 5, 6)  then
			return(2);
		else if MONTH(Data) in (7, 8, 9)  then
			return(3);
		else return(4);
	endsub;

	function bimestre(Data);
		if MONTH(Data) in (1, 2) then
			return(1);
		else if MONTH(Data) in (3, 4)  then
			return(2);
		else if MONTH(Data) in (5, 6)  then
			return(3);
		else if MONTH(Data) in (7, 8)  then
			return(4);
		else if MONTH(Data) in (9, 10)  then
			return(5);
		else return(6);
	endsub;


quit;

options cmplib=work.sas_functions; 
