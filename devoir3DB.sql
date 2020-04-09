GROUPE :  EDMAGH HASNA et CHATI CHAIMA


/////Procedures Stockées*****

///// Q1 ////

CREATE PROCEDURE ajoutPilote ( 
id_pilote IN PILOTE.NOPILOT%TYPE ,
NOMp IN PILOTE.NOM%TYPE ,
VILLEp PILOTE.VILLE%TYPE	,
SALp PILOTE.SAL%TYPE ,
COMMp  PILOTE.COMM%TYPE 	,
EMBAUCHEp  PILOTE.EMBAUCHE%TYPE  

)IS

BEGIN

INSERT INTO PILOTE VALUES(id_pilote,NOMp ,VILLEp,SALp ,COMMp ,EMBAUCHEp ) 
dbms_output.put_line('Pilote crée avec succès');

EXCEPTION

WHEN OTHERS THEN
dbms_output.put_line('Pilote existe deja');


END
/
///// Q2 ////

CREATE PROCEDURE supprimePilote ( 
id_pilote IN PILOTE.NOPILOT%TYPE ,
 )IS

BEGIN

DELETE FROM PILOTE WHERE NOPILOT = id_pilote ;
dbms_output.put_line('Pilote was deleted');

EXCEPTION

WHEN NO_DATA_FOUND THEN
dbms_output.put_line('Pilote n’existe pas ou pilote affecté à un vol');


END
/

///// Q3 ////

CREATE PROCEDURE affichePilote_N  (n IN number)IS

CURSOR c IS 
SELECT NOM FROM PILOTE ;
em c%ROWTYPE ;

BEGIN 
OPEN c ;

LOOP


fetech c INTO em ;

EXIT WHEN (c%ROWCOUNT>n) OR (c%NOTFOUND) ;
dbms_output.put_line(''||em);


ENDLOOP ;
CLOSE c ;


EXCEPTION 
WHEN  OTHERS then 

dbms_output.put_line('n est plus grand que le nombre de n_uplets de la table PILOTE');

END
/

///////////Fonction Stockées*****
/////// Q1)
CREATE OR REPLACE FUNCTION  nombreMoyenHeureVol(famille in pilote.type%type)
RETURN number IS 
   moy number ; 
BEGIN 
   SELECT (AVG(NBHVOL) into moy 
   FROM avion 
   where type=famille
   group by type;
	RETURN moy;
EXCEPTION 
   WHEN no_data_found THEN 
      dbms_output.put_line('nexiste pas'); 
   WHEN others THEN 
      dbms_output.put_line('Error!'); 
END;
/           



///// Paquetages

///// Paquetages numero1

CREATE OR REPLACE PACKAGE GEST_PILOTE IS



//// PROCEDURE1

PROCEDURE afficheP()
declare
   CURSOR pilote_cur is
	select NOPILOT,NOM,VILLE,SAL from pilote;
   pilote_rec pilote_cur%ROWTYPE;
begin
   OPEN pilote_cur;
   LOOP
	FETCH pilote_cur into pilote_rec;
	EXIT WHEN pilote_cur%notfound;

   DBMS_OUTPUT.PUT_LINE('Numero: ' || pilote_rec.NOPILOT || 'Nom: ' || pilote_rec.NOM || 'Ville: ' || pilote_rec.VILLE || 'Salaire: ' || pilote_rec.Sal);	
   ENDLOOP ;
END afficheP ;


//// PROCEDURE2

PROCEDURE P_erre(id_pilote IN PILOTE.NOPILOT%TYPE)
IS
DECLARE 
v_pilote PILOTE%ROWTYPE ;


BEGIN 
SELECT * INTO v_pilote FROM PILOTE WHERE NOPILOT=id_pilote ;
 
 
 if ( v_pilote.SAL>v_pilote.COMM )
 RAISE comm_erreur ;
 
 EXCEPTION
 WHEN comm_erreur THEN 
 dbms_output.put_line('la commission est supérieure au salaire pour CE pilote ');
 
 END P_erre ;
 
 
 //// FUNCTION1
 
 
FUNCTION  Pilote_Ah()
RETURN SYS_REFCURSOR IS
    pilote_cur SYS_REFCURSOR;
	
BEGIN 
	OPEN pilote_cur for 
   		SELECT (count(NOPILOT)
		FROM avion 
  		where NOM LIKE 'Ah%'
   		group by NOPILOT;
	RETURN pilote_cur;
EXCEPTION 
   WHEN no_data_found THEN 
      dbms_output.put_line('n existe pas'); 
   WHEN others THEN 
      dbms_output.put_line('Error!'); 
END Pilote_Ah ;


 //// PROCEDURE3

 PROCEDURE Delete_pilote(delete_No pilote.NOPILOT%TYPE) IS
  
    BEGIN
       DELETE FROM pilote
       WHERE NOPILOT= delete_No;
   END Delete_pilote;
 
 
  //// FUNCTION2
  
  
 FUNCTION  nombreMoyenHeureVol(famille in pilote.type%type)
RETURN number IS 
   moy number ; 
BEGIN 
   SELECT (AVG(NBHVOL) into moy 
   FROM avion 
   where TYPE=famille 
   group by TYPE;
	RETURN moy;
EXCEPTION 
   WHEN no_data_found THEN 
      dbms_output.put_line('n existe pas'); 
   WHEN others THEN 
      dbms_output.put_line('Error!'); 
END nombreMoyenHeureVol ;


 //// PROCEDURE4
PROCEDURE update_pilote(update_No pilote.NOPILOT%TYPE , new_name pilote.Nom%type , new_ville pilote.VILLE%type , new_sal pilote.Sal%type) AS
  
    BEGIN
       update pilote 
	set Nom=new_name;
	set VILLE=new_ville;
	set Sal=new_sal;
       WHERE NOPILOT= update_No;
   END update_pilote;






END GEST_PILOTE ;


//////////////////////////// Paquetages numero2


CREATE OR REPLACE PACKAGE pkgCollectionPilote IS

TYPE tab_Pilotes  IS TABLE OF PILOTE%ROWTYPE INDEX BY BINARY_INTEGER ;

les_Pilotes  tab_Pilotes ;

////


PROCEDURE garnirTabo  IS
    DECLARE
    n BINARY_INTEGER :=0;
    BEGIN
	for pilote_rec in (select Sal from Pilote) LOOP
	n:=n+1;
	les_pilotes(n):=pilote_rec.Sal
	END LOOP
   END garnirTabo ;
   
   
//////


FUNCTION maximum ( sal1 number , sal2 number )
RETURN number  IS max_sal number ;

BEGIN
  IF(sal1>sal2)
  max_sal = sal1 ;
  ELSE 
  max_sal = sal2 ;

RETURN max_sal ;

EXCEPTION
WHEN others THEN 
dbms_output.put_line('Error!'); 
END maximum ;

/////

FUNCTION salMax (tp tab_Pilotes )
RETURN number   IS max number ; 
BINARY_INTEGER i:=0 ;
BEGIN 

LOOP

MAX := maximum ( tp (i) , tp (i+1) ) ;


ENDLOOP 

RETURN MAX ;

EXCEPTION 

   WHEN no_data_found THEN 
   dbms_output.put_line('la table passée en paramètre est vide'); 
   
END  salMax;
  
//////
  
PROCEDURE TriTableau  IS
  
    BEGIN
      select Sal FROM les_Pilotes  order by Sal;
   END TriTableau ;

END pkgCollectionPilote;