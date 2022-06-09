%{
#include "y.tab.h"
#include "string.h"
void yyerror (char *s);
int yylex();

%}

/*program*/
BASLAT		    BASLAT
BITIR		    BITIR

/*veriTipleri*/

TAM_SAYI	    [0-9]+
KELIME		    \".*\"


/*degiskenler*/
DEGISKEN	    [a-zA-Z]


/*parantezler*/
SOL_PARAN	    \(
SAG_PARAN	    \)


/*fonksiyonVeMetotlar*/

TANIMLA         TANIMLA
METOD_ADI       [a-z]+[:]    


/*mantiksalOperatorler*/
VE		    VE 
VEYA    	    VEYA
DEGIL   	    DEGIL

/*ayirmaOperatorler*/
VIRGUL	        ,

/*karsilastirmaOperatorler*/
BUYUKTUR	    >
KUCUKTUR	    <
ESITMI		    ==
BUYUK_ESIT	    >=
KUCUK_ESIT  	    <=
ATAMA		    =


/*kosulluStms*/
EGER		    EGER
YOKSA       	    YOKSA

/*donguStms*/
SURESINCE	    SURESINCE

/*girdiCiktiStms*/
GIRDI_AL	    GIRDI_AL
CIKTI_VER	    CIKTI_VER

/*yorumStms*/
YORUM [^a-zA-Z0-9](##].+[##])[^a-zA-Z0-9]


%%
{BASLAT}                            {return BASLAT ;}
{BITIR}                             {return BITIR ;}
{TAM_SAYI}                          {yylval.num = atoi(yytext); return TAM_SAYI ;}
{TANIMLA}			    {return TANIMLA ;}
{DEGISKEN}                          {return DEGISKEN ;}
{SOL_PARAN}                         {return SOL_PARAN ;}
{SAG_PARAN}                         {return SAG_PARAN ;}
{VE}                                {return VE ;}
{VEYA}                              {return VEYA ;}
{DEGIL}                             {return DEGIL ;}
{VIRGUL}                            {return VIRGUL ;}
{BUYUKTUR}                          {return BUYUKTUR ;}
{KUCUKTUR}                          {return KUCUKTUR ;}
{ESITMI}                            {return ESITMI ;}
{BUYUK_ESIT}                        {return BUYUK_ESIT;}
{KUCUK_ESIT}                        {return KUCUK_ESIT ;}
{ATAMA}                             {return ATAMA ;}
{EGER}                              {return EGER ;}
{YOKSA}                             {return YOKSA ;}
{KELIME}	                    {yylval.pr = strdup(yytext); return KELIME ;}
{SURESINCE}			    {return SURESINCE ;}
{GIRDI_AL}                          {return GIRDI_AL ;}
{CIKTI_VER}                         {return CIKTI_VER ;}
{YORUM}                             {return YORUM ;}
{METOD_ADI}                         {return METOD_ADI ;}
[ \t\n]                             ;
%%

int yywrap(void) {return 1;}
