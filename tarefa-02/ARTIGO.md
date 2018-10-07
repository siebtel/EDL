
## Origens e influências
O nome Prolog foi escolhido por Philippe Roussel como abreviação para _programmation en logique_ (_Programação Lógica_ em francês). A linguagem foi criada em 1972 por Alain Colmerauer com o Philippe Roussel, baseada na Cláula de Horn: uma cláusula (disjunção de literais) com no máximo um literal positivo. Uma tentativa de aproximar a lógica
Em prolog:

    u :- p, q, ..., t.
    
Usando a lógica clássica, essa condição poderia ser escrita assim:

    (p∧q∧...∧t) ➡ u

## Classificação
Prolog é uma linguagem lógica, estática, e é usada principalmente em Inteligencia Artificial (Processamento de linguagem natural) - pela sua facilidade de implementação em buscas de banco de dados -. 

## Comparação
C++ vs Prolog
Lembrando que esse quadro de comparação abaixo não é exato, serve apenas como um guia inicial.
|C++                         |Prolog                 |
|---------------------|----------------------------|
| Função          | Predicados            |
|Tipos          |Termos            |
|Condições       |Regras|

- Criar um banco de dados em prolog é muitos simples, utilizando predicados e termos que constituem os fatos. Depois podemos fazer perguntas para o programa para saber se o fato é *true* ou *false*. Enquanto que em C++, precisamos criar toda a nossa composição da maneira que melhor nos atende. Por exemplo, no nosso caso que veremos a seguir, utilizamos o quê achamos mais otimizado e fácil de implementar, um struct com um campo de vetor de struct com vetores de strings. Enquanto que no Prolog, foram vários fatos, utilizando predicados onde os termos são listas ou átomos.
- Uma outra expressividade é a recursão. Podemos tanto usar a recursão de forma explícita quanto implicitamente. Mostraremos mais nos exemplos a seguir.

## Exemplo 1
Esse exemplo serve para mostrar como é feito a recursão tentando calcular o Fatorial. Em Prolog não temos declarações do tipo de variável, assim como não tem utilização de while. Ambos fazem exatamente o mesmo. Recursão para o cálculo, entrada "infinita", pois como podem ver o while no C++ não tem parada, enquanto que o prolog nem utiliza estrutura de repetição como o while ou o for.
##### Prolog
---
```prolog
fatorial(1, 1). % base case
fatorial(N, Resultado) :- % recursion step
N > 1,
N1 is N - 1,
fatorial(N1, Result1),   
Resultado is Result1 * N.
```

#### C++
---
```C++
#include <iostream>
 
using namespace std;

long long int fatorial(long long int p){
	if (p==0)
		return 1;
	else{
		return p*fatorial(p-1);
	}
}

int main(){
	long long int n;
	while (true){
		cin >> n;
		cout << "fatorial:" << fatorial(n) << endl;
	}
	return 0;
}
```

## Exemplo 2
Já nesse exemplo, há várias diferenças. Usamos recursão (afinal, para percorrer por uma lista, ou por fatos, sempre haverá recursão em prolog). Banco de dados - no caso, colocamos a família da árvore genealógica em outro arquivo para o programa em C++  -. O programa em prolog ainda faz algo mais que o nosso programa em C++ não faz, que é dizer todos os parentes de um criador (o primeiro termo dos predicados "criou( criador, quem foi criado)"). Além de termos utilizado a noção de Árvore.
##### Prolog
---
```prolog
/*Arvore genealogica dos deuses da mitologia grega*/

/*CRIADORES*/
criou(chaos, [tartaro, gaia, eros, nix, erebo, anteros]).
criou(gaia, uranos).
criou([gaia, uranos], 
    [ciclopes, cronos, reia, febe, ceos, 
    hiperiao, japeto, oceano, tetis, equidna]).
criou([reia,cronos],[hestia, demeter, hera, hades, poseidon, zeus] ).
criou([zeus,demeter],[persefone, zagreu]).
criou([zeus,hera],[ares, ilitia, eris, hebe, hefesto, angelo]).
criou([zeus,leto],[apolo, artemis]).

/*CASO SEJA UMA LISTA, USAMOS ESSES PREDICADOS*/
gerou(Parente, Descendente) :- 
    criou(Parente, Lista_Parente),
    member(Descendente, Lista_Parente).  
gerou(Parente, Descendente) :- 
    criou(Lista_Parente, Lista_Descendente), 
    member(Parente, Lista_Parente),
    member(Descendente, Lista_Descendente).

/*CASO SEJA APENAS TERMOS, USAMOS ESSES PREDICADOS*/
gerou(X, Y) :- criou(X,Y).


/*CASO SEJA UMA LISTA, USAMOS ESSES PREDICADOS*/
parente(Parente, Descendente) :- 
    gerou(Parente, Descendente).
/*CASO SEJA APENAS TERMOS, USAMOS ESSES PREDICADOS*/
parente(X, Y) :- parente(X,Z) , gerou(Z,Y)./*busca para ver de Y tem filiação com X*/
```

#### C++
---
```C++
#include<stdlib.h>
#include<iostream>
#include<string>
#include <stdio.h>
using namespace std;

struct familia
{
    string* pais;
    string* filhos;
    int qpais,qfilhos;
};

struct criou
{
    struct familia* relacao;  
    int qrelacao;
}Deuses;

void criarvore()
{
    Deuses.relacao = (struct familia*) malloc(Deuses.qrelacao*sizeof(struct familia));
}

void criafamilia(int np,int nf,int geracao)
{
    Deuses.relacao[geracao].qfilhos=nf;
    Deuses.relacao[geracao].qpais=np;
    Deuses.relacao[geracao].pais = (string* ) malloc(np*sizeof(string));
    Deuses.relacao[geracao].filhos = (string* ) malloc(nf*sizeof(string ));
}

void insereparente(int op,string deus,int at,int geracao)
{
    if(op==1)
    {
        Deuses.relacao[geracao].pais[at]=deus;
    }
    else
    {
        Deuses.relacao[geracao].filhos[at]=deus;
    }
}

bool gerou(string p,string f)
{
    int i,j,k;
    for(i=0;i<Deuses.qrelacao;i++)
    {
        for(j=0;j<Deuses.relacao[i].qpais;j++)
        {
            if(Deuses.relacao[i].pais[j] == p)
            {
                for(k=0;k<Deuses.relacao[i].qfilhos;k++)
                {
                    if(Deuses.relacao[i].filhos[k] == f)
                    {
                        return true;
                    }
                }
            }
        }
    }
    return false;
}

bool parente(string p1,string p2)
{
    int i,j,k;
    if(gerou(p1,p2))
    {
        return true;
    }
    else
    {
        for(i=0;i<Deuses.qrelacao;i++)
        {
            for(j=0;j<Deuses.relacao[i].qpais;j++)
            {
                if(Deuses.relacao[i].pais[j]==p1)
                {
                    for(k=0;k<Deuses.relacao[i].qfilhos;k++)
                    {
                        if(gerou(p1,Deuses.relacao[i].filhos[k]) && parente(Deuses.relacao[i].filhos[k],p2))
                        {
                            return true;
                        }
                    }
                }
            }
            
        }
    }
    return false;
}

int main(int argc, char* argv[])
{
    int i,j,np,nf,op=0;
    bool ligado = true;
    string grego,pai,filho,p1,p2;
    cin>>Deuses.qrelacao;
    criarvore();
    for(i=0;i<Deuses.qrelacao;i++)
    {
        cin>>np>>nf;
        criafamilia(np,nf,i);
        for(j=0;j<np;j++)
        {
            cin>>grego;
            insereparente(1,grego,j,i);
        }
        for(j=0;j<nf;j++)
        {
            cin>>grego;
            insereparente(2,grego,j,i);
        }
    }
    
    while(ligado)
    {
        printf("\n------\nopçoes\n0-termina\n1-gerou\n2-parente\n");
        cin>>op;
        switch(op)
        {
            case 0:
            {
                ligado = false;
                break;
            }
            case 1:
            {
                printf("pai e filho\n");
                cin>>pai>>filho;
                cout<<gerou(pai,filho)<<endl;
                break;
            }
            case 2:
            {
                printf("parente1 e parente2\n");
                cin>>p1>>p2;
                cout<<parente(p1,p2)<<endl;
                break;
            }
            default:
            {
                //ligado = 0;
                break;
            }
        }
    }
}
```
