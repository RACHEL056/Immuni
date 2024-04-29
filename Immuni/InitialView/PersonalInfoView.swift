//
//  PersonalInfoView.swift
//  Immuni
//
//  Created by 박민정 on 4/15/24.
//

import SwiftUI

struct PersonalInfoView: View {
    let genders = ["남성", "여성"]
    let ageRanges = ["10대", "20대", "30대", "40대", "50대", "60대", "70대", "80대"]
    let regions = ["서울", "경기도", "강원도", "충청북도", "충청남도", "전라북도", "전라남도", "경상북도", "경상남도", "제주도"]
    
    let sectionPaddingSize: CGFloat = 40
    let sidePaddingSize: CGFloat = 30
    
    @Environment(\.presentationMode) var presentation

    @State var name : String = ""
    @State var regionindex : Int = 0
    @State var agerangeindex : Int = 0
    @State var genderindex : Int = 0
    @State var temperature : Int = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                HStack {
                    Image("question")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height:200)
                        .padding(.top,70)
                }
                
                Text("당신에 대해 입력해주세요!")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                HStack {
                    Text("이름 : ")
                        .bold()
                    TextField("이름을 입력해주세요!", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.black)
                        .keyboardType(.default)
                    
                }
                .padding(.horizontal, sidePaddingSize)
                
                Text("성별을 선택해주세요")
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                    .bold()
                    .padding(.top, sectionPaddingSize)
                HStack {
                    Picker(selection: $genderindex, label: Text("성별")) {
                        ForEach(0..<genders.count, id: \.self) {
                            Text(self.genders[$0]).tag($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, sidePaddingSize)
                }
                
                Text("연령대를 선택해주세요")
                    .font(.title3)
                    .bold()
                    .padding(.top, sectionPaddingSize)
                HStack {
                    Picker(selection: $agerangeindex, label: Text("나이대")) {
                        ForEach(0..<ageRanges.count, id: \.self) {
                            Text(self.ageRanges[$0]).tag($0)
                                .font(.system(size:100))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width:200, height:50)
                    .padding(.horizontal, sidePaddingSize)
                    .accentColor(.black)
                }
                
                Text("거주하시는 지역을 선택해주세요")
                    .font(.title3)
                    .bold()
                    .padding(.top, sectionPaddingSize)
                
                HStack {
                    Text("현재 온도: \(temperature)℃")
                        .padding()
                    
                    Picker(selection: $regionindex, label: Text("지역선택")) {
                        ForEach(0..<regions.count, id: \.self) {
                            Text(self.regions[$0]).tag($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 100, height: 50)
                    .accentColor(.black)
                    .onChange(of: regionindex) {
                        fetchTemperature()
                    }
                }
                .padding(.horizontal, sidePaddingSize)
                .padding(.bottom, sectionPaddingSize/2)
                
                HStack {
                    Button("저장하기") {
                        //위의 입력된 값들 userInfo에 저장
                        
                        //모달로 띄어진 정보 입력 화면 dismiss
                        presentation.wrappedValue.dismiss()
                    }
                    .foregroundColor(.black)
                    .frame(width: 300, height: 10)
                    .padding()
                    .background(Color.orange.opacity(0.6))
                    .cornerRadius(10)
                }
            }
        }
    }
}

//선택한 지역의 날씨 가져오는 함수
extension PersonalInfoView {
    private func fetchTemperature() {
        let apiKey = "73a8efe415e6c630c9b14946aeefcdba"
        let baseURL = "https://api.openweathermap.org/data/2.5/weather"
        
        let regionQuery: String
        
        switch regionindex {
        case 0:
            regionQuery = "Seoul"
        case 1:
            regionQuery = "Gyeonggi-do"
        case 2:
            regionQuery = "Gangwon-do"
        case 3:
            regionQuery = "Chungcheongbuk-do"
        case 4:
            regionQuery = "Chungcheongnam-do"
        case 5:
            regionQuery = "Jeollabuk-do"
        case 6:
            regionQuery = "Jeollanam-do"
        case 7:
            regionQuery = "Gyeongsangbuk-do"
        case 8:
            regionQuery = "Gyeongsangnam-do"
        case 9:
            regionQuery = "Jeju-do"
        default:
            regionQuery = ""
        }
        
        guard !regionQuery.isEmpty else {
            print("Invalid region selected")
            return
        }
        
        let url = "\(baseURL)?q=\(regionQuery)&appid=\(apiKey)"
        
        guard let apiURL = URL(string: url) else {
            print("Invalid API URL")
            return
        }
        
        URLSession.shared.dataTask(with: apiURL) { data, response, error in
            if let error = error {
                print("Error fetching temperature: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Invalid response data")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let weatherData = json as? [String: Any],
                   let main = weatherData["main"] as? [String: Any],
                   let temp = main["temp"] as? Double {
                    DispatchQueue.main.async {
                        self.temperature = Int(temp - 273)
                    }
                }
            } catch {
                print("Error parsing response data: \(error.localizedDescription)")
            }
        }.resume()
    }
}

#Preview {
    PersonalInfoView(name: "", regionindex: 0, agerangeindex: 0, genderindex: 0, temperature: 0)
}
