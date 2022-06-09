%{
void yyerror (char *s);
int yylex();
int yyerrok;
int yyclearin ;

#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>

int i = 0;

int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
int hafiza[5];
%}

/* Yacc definitions */
%union {int num; char id; char *pr;}         
%start baslat

%token <num> TAM_SAYI
%token <id> DEGISKEN
%token <pr> KELIME

%type <id> atamaIfadesi
%type <num> donguIfadesi
%type <num> dogrulukIfadeleri
%type <num> exp terim dogrulukOperatorleri



%token BASLAT
%token BITIR
%token SOL_PARAN
%token SAG_PARAN
%token VE
%token VEYA
%token DEGIL
%token VIRGUL
%token BUYUKTUR
%token KUCUKTUR
%token ESITMI
%token BUYUK_ESIT
%token KUCUK_ESIT
%token EGER
%token YOKSA
%token SURESINCE
%token GIRDI_AL
%token CIKTI_VER
%token YORUM
%token METOD_ADI
%token ATAMA
%token TANIMLA


/* descriptions of expected inputs     corresponding actions (in C) */

%%
baslat:
	| BASLAT baslat BITIR
	| error
	| ifade
        | ifade baslat
	| baslat ifade
	| BITIR				{exit(EXIT_SUCCESS);}
        ;


ifade:
        | donguIfadesi
	| metodIfadesi
        | atamaIfadesi
        | kosulluIfadeler
        | girdiAlIfadesi
    	| dogrulukIfadeleri
    	| kelimeCiktiVerIfadesi
        | sayiCiktiVerIfadesi
        | yorumIfadesi
        ;


operator:
    	  kiyaslamaOperatorleri
        | dogrulukOperatorleri
    	;

sayiTipi: 
	TAM_SAYI
    	;


exp:
         terim                         		{$$ = $1;}
        | exp '+' terim              		{$$ = $1 + $3;}
        | exp '-' terim              		{$$ = $1 - $3;}
        ;
terim :
    	  TAM_SAYI                        	{$$ = $1;}
        | DEGISKEN                		{$$ = symbolVal($1);}
        ;



kelimeCiktiVerIfadesi:
    	CIKTI_VER KELIME            		{ printf("%s\n",$2); }
    	;

sayiCiktiVerIfadesi:
        CIKTI_VER terim     			{printf("%d\n", $2);}
        ;

atamaIfadesi:
        DEGISKEN ATAMA exp          		{ updateSymbolVal($1,$3); }
        ;

metodIfadesi:
	  TANIMLA METOD_ADI SOL_PARAN terim VIRGUL terim SAG_PARAN  {hafiza[0]=$4; hafiza[1]=$6;}
	| TANIMLA METOD_ADI
	;

yorumIfadesi:
        YORUM
        ;


girdiAlIfadesi:
        GIRDI_AL
        ;


dogrulukIfadeleri:
    
     	TAM_SAYI ESITMI TAM_SAYI    		{$$ = $1 == $3 ;
                    				if($$==1){
                                		printf("DOGRU\n");}
                               			else{
                                		printf("YANLIŞ\n");
                                		}}
    	| TAM_SAYI BUYUKTUR TAM_SAYI     	{$$ = $1 > $3;
                    				if($$==1){
                                		printf("DOGRU\n");}
                               			else{
                                		printf("YANLIŞ\n");
                                		}}
    	| TAM_SAYI BUYUK_ESIT TAM_SAYI   	{$$ = $1 >= $3;
                    				if($$==1){
                                		printf("DOGRU\n");}
                               			else{
                                		printf("YANLIŞ\n");
                                		}}
    	| TAM_SAYI KUCUKTUR TAM_SAYI    	{$$ = $1 < $3;
                    				if($$==1){
                                		printf("DOGRU\n");}
                               			else{
                                		printf("YANLIŞ\n");
                                		}}
    	| TAM_SAYI KUCUK_ESIT TAM_SAYI    	{$$ = $1 <= $3;
                    				if($$==1){
                                		printf("DOGRU\n");}
                               			else{
                                		printf("YANLIŞ\n");
                                		}}
    	| '('dogrulukIfadeleri')'    		{$$ = $2;
                    				if($$==1){
                                		printf("DOGRU\n");}
                               			else{
                                		printf("YANLIŞ\n");
                                		}}
    	;


kosulluIfadeler:
        EGER dogrulukOperatorleri CIKTI_VER KELIME YOKSA CIKTI_VER KELIME              { if(hafiza[0]<+hafiza[1]){
                                            						printf("%s\n", $4);}
											else{
                                               						printf("%s\n", $7);}}  
        ;

donguIfadesi:
    	  SURESINCE terim BUYUKTUR terim CIKTI_VER exp 		{while(i<$2-$4){
                                        			printf("%d\n",$6);
                                        			i +=1;}
								i==0;}
        | SURESINCE terim BUYUKTUR terim exp       		{printf("%d\n", $$ = ($2-$4)*$5);}

    	| SURESINCE terim KUCUKTUR terim CIKTI_VER exp 		{while(i<$4) {   
                                        			i +=1;}
								printf("%d\n",i);
                                        			i == 0;}
	| SURESINCE terim KUCUKTUR terim CIKTI_VER KELIME 	{while(i<$4-$2) {
                                        			printf("%s\n",$6);
                                        			i +=1;} 
                                        			i == 0;}
        | SURESINCE terim KUCUKTUR terim exp        		{printf("%d\n" , $$ = ($4-$2)*$5);}
	;

kiyaslamaOperatorleri:
          sayiTipi atamaOperatorleri sayiTipi
    	| DEGISKEN atamaOperatorleri DEGISKEN
    	| DEGISKEN atamaOperatorleri sayiTipi

        ;

dogrulukOperatorleri:
          terim ESITMI terim            	{ $$ = $1 == $3;}
        | terim BUYUKTUR terim             	{ $$ = $1 > $3;}
        | terim KUCUKTUR terim             	{ $$ = $1 < $3;}
        | terim BUYUK_ESIT terim            	{ $$ = $1 >= $3;}
        | terim KUCUK_ESIT terim            	{ $$ = $1 <= $3;}
    	;

atamaOperatorleri :
           ESITMI
	 | BUYUKTUR
	 | BUYUK_ESIT
	 | KUCUKTUR
	 | KUCUK_ESIT 
         ;
%%                     /* C code */


int computeSymbolIndex(char token)
{
    int idx = -1;
    if(islower(token)) {
        idx = token - 'a' + 26;
    } else if(isupper(token)) {
        idx = token - 'A';
    }
    return idx;
}

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
    int bucket = computeSymbolIndex(symbol);
    return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
    int bucket = computeSymbolIndex(symbol);
    symbols[bucket] = val;
}

int main (void) {
    /* init symbol table */
    int i;
    for(i=0; i<52; i++) {
        symbols[i] = 0;
    }

    return yyparse ( );
}

void yyerror (char *s)
{
printf("SÖZ DİZİMİNİ YANLIS GIRDINIZ.\n");
}
