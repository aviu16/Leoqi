import Foundation

class OpenAIService {
    static let shared = OpenAIService()
    
    func generateImage(using promptMerger: PromptMerger, completion: @escaping (Result<[String], Error>) -> Void) {
        let endpoint = "https://api.openai.com/v1/images/generations"
        guard let url = URL(string: endpoint) else {
            print("OpenAIService Error: Invalid URL")
            completion(.failure(NSError(domain: "OpenAIService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // API key loaded from environment or config — do not hardcode
        guard let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String else {
            completion(.failure(NSError(domain: "OpenAIService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing OPENAI_API_KEY"])))
            return
        }
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let promptText = promptMerger.generatePrompt()
        print("Generating image with prompt: \(promptText)")
        
        let body: [String: Any] = [
            "model": "dall-e-3",
            "prompt": promptText,
            "n": 1,
            "size": "1024x1024"
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Request Body: \(jsonString)")
            }
            request.httpBody = jsonData
        } catch {
            print("OpenAIService Error: Failed to serialize request body - \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("OpenAIService Error: Network request failed - \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
    

            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("OpenAIService Error: Non-HTTP response received")
                completion(.failure(NSError(domain: "OpenAIService", code: 4, userInfo: [NSLocalizedDescriptionKey: "Non-HTTP response received"])))
                return
            }
            
            print("Response Status Code: \(httpResponse.statusCode)")
            if !(200...299).contains(httpResponse.statusCode) {
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Error Response: \(responseString)")
                }
                print("OpenAIService Error: Server returned an error status code")
                completion(.failure(NSError(domain: "OpenAIService", code: 5, userInfo: [NSLocalizedDescriptionKey: "Server returned an error status code"])))
                return
            }
            
            guard let data = data else {
                print("OpenAIService Error: No data received")
                completion(.failure(NSError(domain: "OpenAIService", code: 6, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let data = json["data"] as? [[String: Any]] {
                    let urls = data.compactMap { $0["url"] as? String }
                    print("Image generated successfully: \(urls)")
                    completion(.success(urls))
                } else {
                    print("OpenAIService Error: Failed to parse JSON response")
                    completion(.failure(NSError(domain: "OpenAIService", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON response"])))
                }
            } catch {
                print("OpenAIService Error: JSON parsing failed - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
