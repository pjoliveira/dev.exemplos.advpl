#include "totvs.ch"
// #include "tlpp-core.th"
// #include "tlpp-rest.th"

//=====================================================================================
// ExecutaRotina - PJ Oliveira - Janeiro 2022
//-------------------------------------------------------------------------------------
//Descrição
// executando as qualquer rotina indicada no get
//-------------------------------------------------------------------------------------
//Parametros
// nil
//-------------------------------------------------------------------------------------
//Retorno
// nil
//=====================================================================================

// NAMESPACE custom.testedefuncoes.ExecutarFonte

/*/{Protheus.doc} ExecutaFonte
excuta qualquer rotina indicada no Tget
	@type function
	@version 12,1.2310 
	@author paulo
	@since 4/1/2025
	@return variant, nil
/*/
User Function ExecutaFonte()

	local oBtBusca := Nil
	Local oDlg1    := Nil
	Local oGet     := Nil
	Private cGet := Space(200)
	
	DEFINE MSDIALOG oDlg1 FROM 000,000 TO 150, 400 PIXEL TITLE "Executar"

		oGet     := TGet()   :New(10, 10, bSETGET(cGet), oDlg1, 130                  , 10 , "@!", {|| }, , ,    , , , .T., , , , , , , .F., , ,)
		
		oBtBusca := tButton():New(25, 10, "Executar"   , oDlg1, {|| FSExecuta(cGet) }, 030, 012 ,      , , , .T.)
		
	ACTIVATE MSDIALOG oDlg1
	
Return()

/*/{Protheus.doc} FSExecuta
executa qualquer rotina indicada no Tget
	@type function
	@version 12.1.2310
	@author paulo
	@since 01/04/2025
	@param cGet, character, string com a rotina a ser executada
	@return variant, nil
/*/
Static Function FSExecuta(cGet)

	If Empty(cGet)
		u_ExecutaTestes()
	EndIf 

	xConteudo := &(AllTrim(cGet))

	
Return()
