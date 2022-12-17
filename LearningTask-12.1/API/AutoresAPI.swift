//
//  AutoresAPI.swift
//  LearningTask-12.1
//
//  Created by rafael.rollo on 03/08/2022.
//

import Foundation

/**
 Componente cliente da api de autores da casa do código.
 Implementação atual apenas simula um carregamento.
 Integrações com serviços HTTP estão fora do escopo da atividade atual e será tema mais a frente
 */
class AutoresAPI {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    private var dataTask: URLSessionDataTask?
    
    init(session: URLSession = URLSession.shared,
         decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }

    func listaTodos(completionHandler: @escaping ([Autor]) -> Void,
                    failureHandler: @escaping (AutoresAPI.Error) -> Void) {
        dataTask?.cancel()
        
        let url = URL(string: "https://casadocodigo-api.herokuapp.com/api/author")!
        
        dataTask = session.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    failureHandler(.falhaAoProcessarRequisicao(error))
                }
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                DispatchQueue.main.async {
                    failureHandler(.falhaAoObterResposta)
                }
                return
            }
                
            do {
                guard let self = self else { return }
                
                let autores = try self.decoder.decode([Autor].self, from: data)
                
                DispatchQueue.main.async {
                    completionHandler(autores)
                }
                
            } catch {
                DispatchQueue.main.async {
                    failureHandler(.dadosInvalidos)
                }
            }
        }
        
        dataTask?.resume()
    }
    
}

extension AutoresAPI {
    typealias SError = Swift.Error
    
    enum Error: SError, LocalizedError {
        case falhaAoProcessarRequisicao(SError)
        case falhaAoObterResposta
        case dadosInvalidos
        
        var errorDescription: String? {
            switch self {
            case .falhaAoProcessarRequisicao(let error):
                return "Erro ao processar a requisição \(error.localizedDescription)"
                
            case .falhaAoObterResposta:
                return "Erro ao obter resposta do servidor"
                
            case .dadosInvalidos:
                return "Os dados recebidos do servidor são inválidos"
            }
        }
    }
}
