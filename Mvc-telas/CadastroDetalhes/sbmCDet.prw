#include "Totvs.ch"
#include "FwMvcDef.ch"

/*/{Protheus.doc} sbmCDet
tela de demonstração de cadastro simples em mvc MODELO 3
para o correto funcionamento da tela o nome da user function dever ser o mesmo nome do arquivo
    @type function
    @version 12.1.2410
    @author pjoliveira
    @since 25/05/2025
    @return logical, .t. se tudo certo.
/*/
user function sbmCDet()
    // declaro as variaveis
    local lRet as logical
    local aArea as array
    Local oBrowse 	As Object	
    Local oAuxMvc 	As Object

    // inicializo as variaveis 
    lRet := .t.
    aArea := FWGetArea()
    oAuxMvc := sbmDetAux():New()   

    // criaro o objeto FwMBrowse()
	oBrowse := FwMBrowse():New()
	oBrowse:SetAlias(oAuxMvc:getMasterAlias())
	oBrowse:SetDescription(oAuxMvc:getDescTela())
	oBrowse:DisableDetails()

	// Se Existir, Definir a legenda
	// oBrowse:AddLegend( "ZAF_STATUS=='V'", "GREEN", "Vigente" )
	// oBrowse:AddLegend( "ZAF_STATUS=='E'", "RED" , "Encerrado" )

	oBrowse:Activate()

    // restauro a area salva
    FWRestArea(aArea) 
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
	
    // aAdd( aMenu, { 'Visualizar', 'VIEWDEF.SBMCDET', 0, MODEL_OPERATION_VIEW  , 0, NIL } )   //1
	aAdd( aMenu, { 'Incluir'   , 'VIEWDEF.SBMCDET', 0, MODEL_OPERATION_INSERT, 0, NIL } )   //3
	aAdd( aMenu, { 'Alterar'   , 'VIEWDEF.SBMCDET', 0, MODEL_OPERATION_UPDATE, 0, NIL } )   //4
	aAdd( aMenu, { 'Excluir'   , 'VIEWDEF.SBMCDET', 0, MODEL_OPERATION_DELETE, 0, NIL } )   //5 
	

Return(aMenu)

/*/{Protheus.doc} ModelDef
modelo da tela
    @type function
    @version 12.1.2410
    @author pjoliveira
    @since 25/05/2025
    @return object, modelo da tela
/*/
static function ModelDef() As Object
    Local oModel        As Object
    Local oAuxMvc 	As Object
    Local oMasterStruct 	As Object   // estrutura para o cabecalho
    Local oDetailStruct 	As Object   // estrutura para o detail
    Local aRelacao       As Array
    Local bPosValidacao As Block
    Local bCommit       As Block

    oAuxMvc := sbmDetAux():New()   

    bPosValidacao := { |oModel| oAuxMvc:PosValidacao( oModel ) } 
    bCommit       := { |oModel| oAuxMvc:CommitDados( oModel ) } 

    oMasterStruct := FwFormStruct(1, oAuxMvc:getMasterAlias() /*,{|cCampo| Alltrim(cCampo) $ (cCabec+cCabecA+cCabecE) }*/)   
    oDetailStruct := FwFormStruct(1, oAuxMvc:getDetailAlias() /*,{|cCampo| Alltrim(cCampo) $ (cCabec+cCabecA+cCabecE) }*/)   

	// oStruct1:SetProperty('SBM_COD' , MODEL_FIELD_NOUPD, .T.) // dexa o campo somente leitura na alteração 
	// oStruct1:SetProperty('SBM_LOJA', MODEL_FIELD_NOUPD, .T.)
	
	oModel := MpFormModel():New("SBMDETPE01", /*bPreValidacao*/ ,;
										      bPosValidacao ,;
										      bCommit       ,;
											  /*Cancel*/         )
	oModel:AddFields("MODELSBM_MASTER",/*cOwner*/,;
									      oMasterStruct  ,;
									    /*bPreValidacao*/,;
									    /*bPosValidacao*/,;
									    /*bCarga*/        )
    
    oModel:AddGrid('SB1_DETAIL','MODELSBM_MASTER',oDetailStruct,;
                                                /*bPreLinha*/,;
                                                 /*bPostLinha*/,;
                                                 /*bPreGridTodo - Grid Inteiro*/,;
                                                 /*bPosGridTodo - Grid Inteiro*/,;
                                                 /*bLoad - Carga do modelo manualmente*/ )  

    //Fazendo o relacionamento Master e Detail
    aRelacao := {}
    aAdd(aRelacao, {'B1_FILIAL',    'BM_FILIAL'} )
    aAdd(aRelacao, {'B1_GRUPO' ,    'BM_GRUPO' } ) 

    oModel:SetRelation('SB1_DETAIL', aRelacao, SB1->(IndexKey(1)))      //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SB1_DETAIL'):SetUniqueLine({"B1_FILIAL","B1_COD"})   //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})

    //Setando as descrições
    oModel:SetDescription("Grupo de Produtos - Mod. 3")
    oModel:GetModel('MODELSBM_MASTER'):SetDescription('Modelo Grupo')
    oModel:GetModel('SB1_DETAIL'     ):SetDescription('Modelo Produtos')

    // oModel:GetModel("MODELSBM_MASTER"):SetDescription(OemtoAnsi("Grupo de produtos"))

return(oModel)


/*/{Protheus.doc} ViewDef
criando a static function viewDef
    @type function
    @version 12.1.2410
    @author pjoliveira
    @since 25/05/2025
    @return object, view da tela
/*/
Static Function ViewDef() as Object
    Local oView as Object
    Local oModel       As Object
    Local oAuxMvc 	As Object
    Local oMasterStruct 	As Object   // estrutura para o cabecalho
    Local oDetailStruct 	As Object   // estrutura para o detail
    
    oAuxMvc := sbmDetAux():New()   

    oMasterStruct := FwFormStruct(2, oAuxMvc:getMasterAlias() /*,{|cCampo| Alltrim(cCampo) $ cCabec }*/)
    oDetailStruct := FwFormStruct(2, oAuxMvc:getDetailAlias() /*,{|cCampo| Alltrim(cCampo) $ cCabec }*/)

    oModel 	:= FwLoadModel("SBMCDET")
	oView	:= FwFormView():New()
    oView:SetModel(oModel)

    
    //Adicionando os campos do cabeçalho e o grid dos filhos
    oView:AddField("VIEWSBM_MASTER" ,oMasterStruct,"MODELSBM_MASTER")
    oView:AddGrid('VIEWSB1_DETAIL'  ,oDetailStruct,'SB1_DETAIL')

    //Setando o dimensionamento de tamanho
    oView:CreateHorizontalBox('CABEC',60)
    oView:CreateHorizontalBox('GRID',40)

    //Amarrando a view com as box
    oView:SetOwnerView('VIEWSBM_MASTER','CABEC')
    oView:SetOwnerView('VIEWSB1_DETAIL','GRID')

    //Habilitando título
    oView:EnableTitleView('VIEWSBM_MASTER','Grupo')
    oView:EnableTitleView('VIEWSB1_DETAIL','Produtos')

    //Força o fechamento da janela na confirmação
	//oView:SetCloseOnOk({||.T.})


Return(oView)

/*/{Protheus.doc} sbmDetAux
Criando uma classe para auxiliar o sbmCad
    @type class
    @version 12.1.2410  
    @author paulo
    @since 25/05/2025
    /*/
class sbmDetAux
    private data cDescTela as character
    private data cMasterAlias as character    
    private data cDetailAlias as character    

    public method new()
    public method setDescTela(cDescTela as character)
    public method getDescTela() as character
    public method setBrowse(oBrowse as object)
    public method getBrowse() as object
    public method setMasterAlias(cAlias as character)
    public method getMasterAlias() as character
    public method setDetailAlias() as character
    public method getDetailAlias() as character

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
Method new() Class sbmDetAux


    ::setDescTela(OemtoAnsi("Tela MVC Master/Detail - SBM/SB1"))
    ::setMasterAlias("SBM")
    ::setDetailAlias("SB1")

    
Return 

/*/{Protheus.doc} setMasterAlias
seta o alias da tela
    @type method
    @version 12.1.2410
    @author pjoliveira
    @since 10/04/2025
    @param cAlias, character, qual o alias padrão da tabela
@return variant, nil
/*/
Method setMasterAlias(cAlias as character) Class sbmDetAux
    // seta o alias da tela
    ::cMasterAlias := cAlias
Return

/*/{Protheus.doc} setDetailAlias
seta o master alias da tela
@type method
@version 12.1.2410 
@author paulo
@since 5/25/2025
@param cAlias, character, alias master da tela
@return variant, nil
/*/
Method setDetailAlias(cAlias as character) Class sbmDetAux
    // seta o alias da tela
    ::cDetailAlias := cAlias
Return

/*/{Protheus.doc} GetMasterAlias
get o alias da tela
    @type method
    @version 12.1.2410
    @author pjoliveira
    @since 10/04/2025
    @return character, string com o alias da tabela
/*/
Method GetMasterAlias() as character Class sbmDetAux
    // retorna o alias da tela
Return ::cMasterAlias

/*/{Protheus.doc} getDetailAlias
get o detail alias da tela
@type method
@version 12.1.2410
@author pjoliveira
@since 25/05/2025
@return character, detail alias da tela
/*/
Method getDetailAlias() as character Class sbmDetAux
    // retorna o alias da tela
Return ::cDetailAlias

/*/{Protheus.doc} setDescTela
seta a descrição da tela
    @type method
    @version 12.1.2410
    @author pjoliveira
    @since 10/04/2025
    @param cDescTela, character, descrição da tela
    @return variant, nil
/*/
Method setDescTela(cDescTela as character) Class sbmDetAux
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
Method getDescTela() as character Class sbmDetAux
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
Method PosValidacao(oModel as object) as logical Class sbmDetAux
    Local lRet as logical
    Local oModelCabec as Object
    Local nOperation as Numeric

    lRet := .t.
    oModelCabec := oModel:GetModel("MODELSBM_MASTER")
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
Method CommitDados(oModel as object) as logical Class sbmDetAux
    Local lRet as logical
    Local oModelCabec as Object
    Local nOperation as Numeric

    lRet := .T.
    oModelCabec := oModel:GetModel("MODELSBM_MASTER")
    nOperation := oModel:GetOperation()	
	
	// If (nOperation == MODEL_OPERATION_INSERT) // 3 - Inclusão 
        // Caso tenha que gravar alguns dados automaticamente
		// oZAFModel:SetValue( 'ZAF_DTCAD',  Date())
		// oZAFModel:SetValue( 'ZAF_HRCAD',  Substr( Time(), 1, 2) + Substr( Time(), 4, 2) )			
	// EndIf 
    	
	//oModel:VldData()
	lRet := FWFormCommit( oModel )


Return(lRet)
