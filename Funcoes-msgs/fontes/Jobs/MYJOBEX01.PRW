/* 
PROGRAMA EM ADVPL (.PRW) PARA SER EXECUTADO NO SCHEDULE DO PROTHEUS.
*/
#INCLUDE "totvs.ch"
/*/{Protheus.doc} MyJobEx01
programa para execução no schedule do protheus - jobs
    @type function
    @version 12.1.2410
    @author paulo oliveira
    @since 16/08/2025
    @return variant, .t. se deu certo
/*/
User Function MyJobEx01(aEmpresaFilial as array) 
    Local lRet as Logical
    Local cEmpJob as Character // recebe a empresa passada no parametro da função 
    Local cFilJob as Character // recebe a filial passada no parametro da função 

    Private lWorkFlow := .f. 

    Default aEmpresaFilial := {"99", "01"}

    lRet := .T.
    cEmpJob := aEmpresaFilial[1] // pega a empresa do array
    cFilJob := aEmpresaFilial[2] // pega a filial do array

    // inicializar os ambietes do protheus 
    lWorkFlow := .T.
    
    RpcSetType(2)

    // log de início
    FWLogMsg("INFO", "MyJobEx01", "Processo iniciado " + cEmpJob + "/" + cFilJob + " - " + StrTran(Time(),":",""))
    // FWLogMsg("WARN", "MyJobEx01", "Cliente sem e-mail")
    // FWLogMsg("ERROR", "MyJobEx01", "Erro ao acessar SF2")

    RpcSetEnv(cEmpJob,cFilJob,,,"FIN",GetEnvServer(),{"SE1"})

    // chamada do metodo para ser executado pelo JOB
    FSTitulos()

    RpcClearEnv()
    lWorkFlow := .F.

    // log de término
    FWLogMsg("INFO", "MyJobEx01", "Processo finalizado " + cEmpJob + "/" + cFilJob + " - " + StrTran(Time(),":",""))

Return(lRet)

/*/{Protheus.doc} FSTitulos
função de testes apenas 
    @type function
    @version 12.1.2410
    @author paulo oliveira
    @since 16/8/2025
    @return variant, .t. se tudo der certo
/*/
Static Function FSTitulos()
    Local lRet as Logical
    Local aArea as array
    
    lRet := .T.
    aArea := FWGetArea()

    // lógica para enviar títulos

    SE1->(DbsetOrder("SE1"))
    SE1->(DbGoTop())
    SE1->(DbSkip())

    
    // restauro a area salva
    FWRestArea(aArea) 

Return(lRet)
