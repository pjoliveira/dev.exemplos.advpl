#include "Totvs.ch"
#include "FwMvcDef.ch"

/*/{Protheus.doc} sbmCad
tela de demonstração de cadastro simples em mvc MODELO 1
    @type function
    @version 12.1.2410
    @author pjoliveira
    @since 20/04/2025
    @return logical, .t. se tudo certo.
/*/
user function sbmCad()
    // declaro as variaveis
    local lRet as logical
    Local oBrowse 	As Object	
    Local oSbmCadAux 	As Object

    lRet := .t.
    
	oSbmCadAux := sbmCadAux():New()   

	oBrowse := FwMBrowse():New()
	oBrowse:SetAlias(oSbmCadAux:getAlias())
	oBrowse:SetDescription(oSbmCadAux:getDescTela())
	oBrowse:DisableDetails()

	// Definição da legenda
	// oBrowse:AddLegend( "ZAF_STATUS=='V'", "GREEN", "Vigente" )
	// oBrowse:AddLegend( "ZAF_STATUS=='E'", "RED" , "Encerrado" )
	oBrowse:Activate()


Return(lRet)

/*/{Protheus.doc} MenuDef
Criando a static function MenuDef
    @type function
    @version 12.1.2410
    @author pjoliveira
    @since 10/04/2025
    @return array, array com os itens do menu
/*/
static function MenuDef() as Array 
    Local aMenu as array
    
    // aMenu da Tela
	//------------------------------------------------------------

    aMenu := {}
		
	aAdd( aMenu, { 'Incluir'   , 'VIEWDEF.SBMCAD', 0, MODEL_OPERATION_INSERT, 0, NIL } )   //3
	aAdd( aMenu, { 'Alterar'   , 'VIEWDEF.SBMCAD', 0, MODEL_OPERATION_UPDATE, 0, NIL } )   //4
	aAdd( aMenu, { 'Excluir'   , 'VIEWDEF.SBMCAD', 0, MODEL_OPERATION_DELETE, 0, NIL } )   //5 
	

Return(aMenu)

/*/{Protheus.doc} ModelDef
modelo da tela
    @type function
    @version 12.1.2410
    @author pjoliveira
    @since 10/04/2025
    @return object, modelo da tela
/*/
static function ModelDef() As Object
    Local oModel        As Object
    Local oSbmCadAux 	As Object
    Local oStruct1 	    As Object   // estrutura para o cabecalho
    Local bPosValidacao As Block
    Local bCommit       As Block

    oSbmCadAux := sbmCadAux():New()   

    bPosValidacao := { |oModel| oSbmCadAux:PosValidacao( oModel ) } 
    bCommit       := { |oModel| oSbmCadAux:CommitDados( oModel ) } 

    oStruct1 := FwFormStruct(1, oSbmCadAux:getAlias() /*,{|cCampo| Alltrim(cCampo) $ (cCabec+cCabecA+cCabecE) }*/)   

	// oStruct1:SetProperty('SBM_COD' , MODEL_FIELD_NOUPD, .T.) // dexa o campo somente leitura na alteração 
	// oStruct1:SetProperty('SBM_LOJA', MODEL_FIELD_NOUPD, .T.)
	
	oModel := MpFormModel():New("SBMCADPE01", /*bPreValidacao*/ ,;
										      bPosValidacao ,;
										      bCommit       ,;
											  /*Cancel*/         )
	oModel:AddFields("MODELSBMCAD_CABEC",/*cOwner*/,;
									      oStruct1  ,;
									    /*bPreValidacao*/,;
									    /*bPosValidacao*/,;
									    /*bCarga*/        )

    // oModel:GetModel("MODELSBMCAD_CABEC"):SetDescription(OemtoAnsi("Grupo de produtos"))
	oModel:SetPrimaryKey( {"BM_FILIAL","BM_GRUPO"} )

return(oModel)


/*/{Protheus.doc} ViewDef
criando a static function viewDef
    @type function
    @version 12.1.2410
    @author pjoliveira
    @since 10/04/2025
    @return object, view da tela
/*/
Static Function ViewDef() as Object
    Local oView as Object
    Local oModel       As Object
    Local oSbmCadAux 	As Object
    Local oStruct1 	    As Object   // estrutura para o cabecalho
    
    oSbmCadAux := sbmCadAux():New()   

    oStruct1 := FwFormStruct(2, oSbmCadAux:getAlias() /*,{|cCampo| Alltrim(cCampo) $ cCabec }*/)

    oModel 	:= FwLoadModel("SBMCAD")
	oView	:= FwFormView():New()

    oView:SetModel(oModel)

    oView:AddField("VIEWSBMCAD_CABEC" ,oStruct1,"MODELSBMCAD_CABEC")

    oView:CreateHorizontalBox("H_TOP1",100)
    oView:SetOwnerView("VIEWSBMCAD_CABEC" ,"H_TOP1")
    //oView:EnableTitleView('VIEWSBMCAD_CABEC' ,OemtoAnsi('Grupo de Produtos'))

    //Força o fechamento da janela na confirmação
	oView:SetCloseOnOk({||.T.})

Return(oView)

/*/{Protheus.doc} sbmCadAux
Criando uma classe para auxiliar o sbmCad
    @type class
    @version 12.1.2410  
    @author paulo
    @since 10/04/2025
    /*/
class sbmCadAux
    private data cDescTela as character
    private data cAlias as character    

    public method new()
    public method setDescTela(cDescTela as character)
    public method getDescTela() as character
    public method setBrowse(oBrowse as object)
    public method getBrowse() as object
    public method setAlias(cAlias as character)
    public method getAlias() as character

    public method PosValidacao(oModel as object) as logical
    public method CommitDados(oModel as object) as logical


EndClass

/*/{Protheus.doc} new
Construtor da classe
    @author pjoliveira
    @type method
    @since 10/04/2025
    @version 12.1.2410
/*/
Method new() Class sbmCadAux



    ::setDescTela(OemtoAnsi("Cadastro MVC Simples - SBM"))
    ::setAlias("SBM")

    
Return 

/*/{Protheus.doc} setAlias
seta o alias da tela
    @type method
    @version 12.1.2410
    @author pjoliveira
    @since 10/04/2025
    @param cAlias, character, qual o alias padrão da tabela
@return variant, nil
/*/
Method setAlias(cAlias as character) Class sbmCadAux
    // seta o alias da tela
    ::cAlias := cAlias
Return

/*/{Protheus.doc} GetAlias
get o alias da tela
    @type method
    @version 12.1.2410
    @author pjoliveira
    @since 10/04/2025
    @return character, string com o alias da tabela
/*/

Method GetAlias() as character Class sbmCadAux
    // retorna o alias da tela
Return ::cAlias
/*/{Protheus.doc} setDescTela
seta a descrição da tela
    @type method
    @version 12.1.2410
    @author pjoliveira
    @since 10/04/2025
    @param cDescTela, character, descrição da tela
    @return variant, nil
/*/
Method setDescTela(cDescTela as character) Class sbmCadAux
    // seta a descrição da tela
    ::cDescTela := cDescTela
Return

/*/{Protheus.doc} getDescTela
get a descrição da tela
    @type method
    @version 12.1.2410
    @author paulo
    @since 5/20/2025
    @return character, nil
/*/
Method getDescTela() as character Class sbmCadAux
    // retorna a descrição da tela
Return ::cDescTela

/*/{Protheus.doc} PosValidacao
PosValidacao do modelo
    @type method
    @version 12.1.2310
    @author pjoliveira
    @since 10/04/2025
    @param oModel, object, modelo da tela
    @return logical, .t. se validou tudo certo
/*/
Method PosValidacao(oModel as object) as logical Class sbmCadAux
    Local lRet as logical
    Local oModelCabec as Object
    Local nOperation as Numeric

    lRet := .t.
    oModelCabec := oModel:GetModel("MODELSBMCAD_CABEC")
    nOperation := oModel:GetOperation()	
	
    // Aplicando as boas praticas de Object Calisthenics para eleiminar o ELSE
    //
	If (nOperation <> MODEL_OPERATION_INSERT) // 3 - Inclusão 
        // quando for diferente de INSERT, não validar
        lRet := .T.
        Return(lRet)
    EndIf 

    // // validação do campo de código
    // If Empty(FWFldGet("BM_GRUPO"))
    //     // quando estiver usando MVC as mensagens devem ser feitas com o metodo Help()
    //     Help( ,, OemtoAnsi('Cod Grupo'),, OemtoAnsi('Campo grupo não pode ser vazio.'), 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe o grupo."} )
    //     lRet := .f.
    //     Return(lRet)
    // EndIf
    
    // // validação do campo de descrição
    // If Empty(FWFldGet("BM_DESCR"))
    //     // quando estiver usando MVC as mensagens devem ser feitas com o metodo Help()
    //     Help( ,, OemtoAnsi('Desc Grupo'),, OemtoAnsi('Campo descrição não pode ser vazio.'), 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe a descrição."} )
    //     lRet := .f.
    //     Return(lRet)
    // EndIf


Return(lRet)

/*/{Protheus.doc} CommitDados
comitDados do Modelo
    @type method
    @version 12.1.2410
    @author pjoliveira
    @since 10/04/2025
    @param oModel, object, modelo da tela
    @return logical, .t. se gravou tudo certo
/*/
Method CommitDados(oModel as object) as logical Class sbmCadAux
    Local lRet as logical
    Local oModelCabec as Object
    Local nOperation as Numeric

    lRet := .T.
    oModelCabec := oModel:GetModel("MODELSBMCAD_CABEC")
    nOperation := oModel:GetOperation()	
	
	// If (nOperation == MODEL_OPERATION_INSERT) // 3 - Inclusão 
        // Caso tenha que gravar alguns dados automaticamente
		// oZAFModel:SetValue( 'ZAF_DTCAD',  Date())
		// oZAFModel:SetValue( 'ZAF_HRCAD',  Substr( Time(), 1, 2) + Substr( Time(), 4, 2) )			
	// EndIf 
    	
	//oModel:VldData()
	lRet := FWFormCommit( oModel )


Return(lRet)
