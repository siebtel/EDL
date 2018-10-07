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
/* criou(Parente, Descendente).*/
    criou(Parente, Lista_Descendente),
    member(Descendente, Lista_Descendente).
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
parente(X, Y) :- parente(X,Z) , gerou(Z,Y). /*busca para ver de Y tem filiação com X*/
