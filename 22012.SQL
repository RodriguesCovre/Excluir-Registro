CREATE OR REPLACE TRIGGER AD_DESPFUN_EXCLUI_FIN 
AFTER UPDATE ON AD_DESPFUN
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
/*
 AUTOR: PATRICK
 DATA: 24/04/24
 -------------------------------------------------------
 REQUERENTE E O NUMERO DO CHAMADO: RAFAELA CHAMADO: 22012
 -------------------------------------------------------
 QUANDO ALTERAR O STATUS PARA 'CANCELADO' IRA EXCLUIR O O FINANCEIRO GERADO NA MOVIMENTAÇÃO FINANCEIRA
 */
    P_NUFIN INT;
    V_DHBAIXA DATE;
    V_MSG VARCHAR2(255);
BEGIN
    SELECT NUFIN, DHBAIXA INTO P_NUFIN, V_DHBAIXA FROM TGFFIN WHERE NUFIN = :NEW.NUFIN;
        IF UPDATING ('STATUS') THEN
			IF :NEW.STATUS = 'C' THEN
				IF :NEW.MOTVALTER IS NULL THEN
					Raise_Application_Error (-20343, 'Você tem que preencher o campo "MOTIVO DA ALTERAÇÃO"');
				IF V_DHBAIXA IS NULL THEN
					DELETE FROM TGFFIN WHERE NUFIN = :NEW.NUFIN;
					V_MSG := 'Nr Financeiro: ' || :NEW.NUFIN || ', excluído da tela Movimentação Financeira.';
						ELSE IF :OLD.STATUS = 'C' THEN
							IF :NEW.STATUS != :OLD.STATUS THEN
							Raise_Application_Error (-20343, 'Uma vez cancelado sempre candelado!');
                 			END IF;
                 		END IF;
                	END IF;
                END IF;
            END IF;
        END IF;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
