public with sharing class TicketsController {
    @AuraEnabled(cacheable=true)
    public static List<Aeroporto__c> getAeroportos(String search){
        search += '%';

        return [SELECT Id, Name, Estado__r.Name, Sigla__c 
        FROM Aeroporto__c
        WHERE Name like :search OR
            Estado__r.Name like :search OR
            Sigla__c like :search
        WITH SECURITY_ENFORCED]; //with security_enforced eu informo que os dados só vão vir, se o user do contexto tem realmente acesso aquele campo e objeto
    }

    //2020-12-15 parse 15/12/2020, é isso que este método vai fazer
    //pq ele vem como string
    private static Date dataParse(String dateString){
        List<String> dt = dateString.split('-'); /* com split, 2020 fica posicao 0, 12 posicao 1, 15 posicao 2, split é para te ajudar a identificar o separador */
        Date dtResult = Date.newInstance(Integer.valueOf(dt.get(0)), Integer.valueOf(dt.get(1)), Integer.valueOf(dt.get(2)));

        return dtResult;
    }

    @AuraEnabled
    public static List<RetornoVooTO> getVoos(String aeroportoOrigem, String aeroportoDestino, String dataPartida, String dataRetorno){
        Date dtPartida = dataParse(dataPartida);
        Date dtRetorno = dataParse(dataRetorno);

        List<Voo__c> voosOrigem = [SELECT Id, Name, Aeroporto_Chegada__r.Sigla__c, Aeroporto_Partida__r.Sigla__c, Valor__c,
        Duracao__c, Companhia__c, Hora_de_Partida__c, Hora_de_Chegada__c, Data_Partida__c, Data_Chegada__c
        FROM Voo__c
        WHERE Data_Partida__c =: dtPartida AND Aeroporto_Partida__c = :aeroportoOrigem AND Aeroporto_Chegada__c = :aeroportoDestino
        WITH SECURITY_ENFORCED];
        
        List<Voo__c> voosDestino = [SELECT Id, Name, Aeroporto_Chegada__r.Sigla__c, Aeroporto_Partida__r.Sigla__c, Valor__c,
        Duracao__c, Companhia__c, Hora_de_Partida__c, Hora_de_Chegada__c, Data_Partida__c, Data_Chegada__c
        FROM Voo__c
        WHERE Data_Partida__c =: dtRetorno AND Aeroporto_Partida__c = :aeroportoDestino AND Aeroporto_Chegada__c = :aeroportoOrigem
        WITH SECURITY_ENFORCED];

        List<RetornoVooTO> result = new List<RetornoVooTO>();
        for(Voo__c vooOrigem : voosOrigem){
            for(Voo__c vooDestino : voosDestino){
                result.add(new RetornoVooTO(vooOrigem, vooDestino));
            }
        }
        System.debug(result);
        return result;
    }

    @AuraEnabled
    public static Ticket__c createTicket(String accountId, String vooIdaId, String vooRetornoId){
        if(Schema.SObjectType.Ticket__c.isCreateable()){
            Ticket__c ticket = new Ticket__c();
            ticket.Account__c = accountId;
            ticket.Voo_Ida__c = vooIdaId;
            ticket.Voo_Volta__c = vooRetornoId;
    
            insert ticket;
    
            return ticket;
        } else {
            throw new AuraHandledException('Você não tem permissão para criar Tickets de Voo');
        }
    }

    public class RetornoVooTO{
        @AuraEnabled
        public Voo__c vooIda;
        @AuraEnabled
        public Voo__c vooVolta;

        public RetornoVooTO(Voo__c vooIda, Voo__c vooVolta){
            this.vooIda = vooIda;
            this.vooVolta = vooVolta;
        }
    }
}