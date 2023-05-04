%macro commandShell(COMMAND);
	%global CommandShellOut;
	%let CommandShellOut='';
	%put SAÍDA COMANDO SHELL:;
	filename saida pipe &COMMAND;

	data _null_;
		infile saida;
		input;
		CALL SYMPUT('CommandShellOut',STRIP(_infile_));
		PUT _infile_;
	run;
%mend commandShell;
