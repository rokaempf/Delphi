
source("get_authentification_token.R")

token <- get_authentifaction_token(client_url, auth_query)


headers <- list(
  Authorization = paste0('Bearer ', token)
)


con <- ghql::GraphqlClient$new(
  url = client_url,
  headers = headers
)

#con$load_schema() #does not work

qry <- ghql::Query$new()


qry$query('test', paste('query {
  proben(last: 100) {
    nodes {
      protokollnummerMitPruefziffer
      id
      auftrag {
        auftragsnummer
        id
      }
    }
  }
}'))




qry$queries$test

data <- con$exec(qry$queries$test)

tb <- data |> jsonlite::fromJSON(flatten = T) 

data_tibble <- tb$data$proben$nodes |> tibble::as_tibble()

qry2 <- ghql::Query$new()

qry2$query('withVar', paste('query {
  proben(last: 100) {
    nodes {
      protokollnummerMitPruefziffer
      id
      auftrag {
        auftragsnummer
        id
      }
    }
  }
}'))


variables <- list(
  #how?
)

vardata <- con$exec(qry2$queries$withVar, variables)



'query test($sachbearbeiter: Int) {
  resultate(
    order: {probe: {protokollnummerMitPruefziffer: ASC}}
    where: {
      and: [
        {probe: {
          fkSachbearbeiterId: {eq: $sachbearbeiter}
          probenflussStatus: {neq: PROBE_PRUEFBERICHT_ERSTELLT}
        }
        }
      ]
    }
  )
  {
    totalCount
    nodes {
      probe() {
        protokollnummerMitPruefziffer
        probenflussStatusName
        probenflussStatus
        fkSachbearbeiterId
        
      }
      analytNameKopie
      resultatWert
      einheitKopie
      probenflussStatus
    }
    
  }
}'
