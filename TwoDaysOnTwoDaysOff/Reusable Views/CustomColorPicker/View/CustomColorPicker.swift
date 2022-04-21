//
//  CustomColorPicker.swift
//  CustomColorPicker
//
//  Created by Slik on 14.04.2022.
//

import SwiftUI

struct CustomColorPicker: View {
    
    @Binding var selectedColor: Color
    
    let minBrightness: CGFloat
    let maxBrightness: CGFloat
    
    let minOpacity: CGFloat
    let maxOpacity: CGFloat
    
    let minHSBAUnit: CGFloat
    
    let supportsOpacity: Bool
    let supportsBrightness: Bool
    
    let pickerStyle: CustomColorPicker.PickerStyle
    let colorLabelBackground: CustomColorPicker.ColorLabelBackground
    
    @State private var selectedColorBrightness: Double = 1
    @State private var selectedColorOpacity: Double = 1
    
    @State private var selectedBaseColor: Color = .clear
    
    @State private var recentColors: [Color] = []
    
    var body: some View {
        VStack(spacing: 15) {
            baseColorPicker
                .padding(.horizontal, -16)
            Divider()
            sliders
            HStack(spacing: 0) {
                selectedColorLabel
                VStack(spacing: 10) {
                    recentColorsControlBar
                    recentColorPicker
                        .padding(.trailing, -16)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 85, alignment: .leading)
        }
        .padding()
        .onChange(of: selectedColorBrightness) { newValue in
            updateSelectedColor()
        }
        .onChange(of: selectedColorOpacity) { newValue in
            updateSelectedColor()
        }
        .onAppear {
            recentColors.append(selectedColor)
            updateHSBAValues()
        }
    }
    
    private func updateSelectedColor() {
        let hsv = selectedColor.uiColor.hsbaComponents
        let brightness = supportsBrightness ? selectedColorBrightness : hsv.brightness
        selectedColor = Color(hue: hsv.hue, saturation: hsv.saturation, brightness: brightness, opacity: selectedColorOpacity)
    }
    
    private func updateHSBAValues() {
        selectedColorBrightness = selectedColor.uiColor.hsbaComponents.brightness
        selectedColorOpacity = selectedColor.uiColor.hsbaComponents.alpha
    }
    
    private func dropSelectedBaseColor() {
        selectedBaseColor = .clear
    }
    
    private var baseColors: [Color] = [
        .init(red: 1, green: 0, blue: 0),                   //red
        .init(red: 1, green: 128/255, blue: 0),             //orange
        .init(red: 1, green: 1, blue: 0),                   //yellow
        .init(red: 0, green: 1, blue: 0),                   //green
        .init(red: 0, green: 1, blue: 1),                   //turquoise
        .init(red: 0, green: 128/255, blue: 1),             //skyBlue
        .init(red: 0, green: 0, blue: 1),                   //blue
        .init(red: 127/255, green: 0, blue: 1),             //violet
        .init(red: 1, green: 0, blue: 1),                   //fuchsia
        .init(red: 1, green: 0, blue: 127/255),             //pink
        .init(red: 128/255, green: 128/255, blue: 128/255)  //gray
    ]
}

extension CustomColorPicker {
    
    @ViewBuilder
    private var baseColorPicker: some View {
        switch pickerStyle {
        case .grid:
            colorsGrid
        case .carousel:
            CarouselPicker(selection: $selectedBaseColor, values: baseColors) { value in
                (value as Color)
                    .clipShape(Circle())
                    .frame(width: 35, height: 35)
                    .overlay(
                        selectedColorMark(isSelected: (selectedColor == value) || (selectedBaseColor == value))
                    )
            } onSelect: { value in
                let hsba = value.uiColor.hsbaComponents
                let brightness = supportsBrightness ? selectedColorBrightness : hsba.brightness
                selectedColor = Color(hue: hsba.hue, saturation: hsba.saturation, brightness: brightness, opacity: selectedColorOpacity)
            }
        }
    }
    
    @ViewBuilder
    private var sliders: some View {
        VStack(spacing: 5) {
            if supportsBrightness {
                brightnessSlider
            }
            if supportsOpacity {
                opacitySlider
            }
        }
    }
    
    private var brightnessSlider: some View {
        Section {
            Slider(value: $selectedColorBrightness, in: minBrightness...maxBrightness, step: minHSBAUnit)
        } header: {
            Text("BRIGHTNESS")
                .foregroundColor(.secondary)
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var opacitySlider: some View {
        Section {
            Slider(value: $selectedColorOpacity, in: minOpacity...maxOpacity, step: minHSBAUnit)
        } header: {
            Text("OPACITY")
                .foregroundColor(.secondary)
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var selectedColorLabel: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(selectedColor)
            .frame(width: 85, height: 85)
            .background(colorBackground.cornerRadius(8))
            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.2), style: .init(lineWidth: 1)))
    }
    
    private var recentColorsControlBar: some View {
        HStack {
            addColorToRecentButton
            if !recentColors.isEmpty {
                dropLastRecentColorButton
            }
        }
        .frame(maxWidth: .infinity, alignment: .topTrailing)
        .animation(.easeOut)
    }
    
    private var addColorToRecentButton: some View {
        Button {
            recentColors.append(selectedColor)
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.title)
                .foregroundColor(.gray.opacity(0.5))
        }
    }
    
    private var dropLastRecentColorButton: some View {
        Button {
            recentColors = recentColors.dropLast()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.title)
                .foregroundColor(.gray.opacity(0.5))
        }
    }
    
    private var recentColorPicker: some View {
        CarouselPicker(selection: $selectedColor, values: recentColors) { value in
            (value as Color)
                .clipShape(Circle())
                .frame(width: 35, height: 35)
                .overlay(selectedColorMark(isSelected: selectedColor == value))
                .background(colorBackground.clipShape(Circle()))
        } onSelect: { value in
            updateHSBAValues()
            dropSelectedBaseColor()
        }
    }
    
    @ViewBuilder
    private func selectedColorMark(isSelected: Bool) -> some View {
        if isSelected {
            Circle()
                .stroke(Color("themeSecondary"), lineWidth: 3)
                .frame(width: 28, height: 28)
        }
    }
    
    @ViewBuilder
    private var colorBackground: some View {
        switch colorLabelBackground {
        case .grid:
            Grid(hasBorder: false)
        case .gradient:
            LinearGradient(
                gradient: Gradient(stops: [
                    Gradient.Stop(color: .black, location: 0.5),
                    Gradient.Stop(color: .white, location: 0.5)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
        }
    }
}

//MARK: BaseColorPickerStyle: Grid
extension CustomColorPicker {
    
    @ViewBuilder
    private var colorsGrid: some View {
        let colors = colorsForGrid
        let rows = rows
        LazyHGrid(rows: rows, spacing: 1) {
            ForEach(colors, id: \.self) { color in
                color
                    .frame(width: 30, height: 30)
                    .overlay(
                        Rectangle()
                            .stroke(color.isDark ? .white : .black.opacity(0.7),
                                    lineWidth:  (selectedColor == color || selectedBaseColor == color) ? 2 : 0)
                    )
                    .onTapGesture {
                        let hsba = color.uiColor.hsbaComponents
                        let brightness = supportsBrightness ? selectedColorBrightness : hsba.brightness
                        selectedColor = Color(hue: hsba.hue, saturation: hsba.saturation, brightness: brightness, opacity: selectedColorOpacity)
                        selectedBaseColor = color
                    }
            }
        }
    }
    
    private var rows: [GridItem] {
        return [
            GridItem(.fixed(30), spacing: 1),
            GridItem(.fixed(30), spacing: 1),
            GridItem(.fixed(30), spacing: 1),
            GridItem(.fixed(30), spacing: 1),
            GridItem(.fixed(30), spacing: 1),
        ]
    }
    
    private var colorsForGrid: [Color] {
        var resultArray: [Color] = []
        let increments = incrementsForRGBAComponents
        let rgbaComponents = baseColors.map { color in
            color.uiColor.rgbaComponents
        }
        for index in 0..<baseColors.count {
            resultArray.append(contentsOf: ColorGenerator.generateColors(rgbaComponents[index],
                                                                         rIncrement: increments[index].0/255,
                                                                         gIncrement: increments[index].1/255,
                                                                         bIncrement: increments[index].2/255,
                                                                         count: 4))
        }
        
        return resultArray
    }
    
    private var incrementsForRGBAComponents: [(Double, Double, Double)] {
        return [
            (0, 51, 51), //red
            (0, 25, 51), //orange
            (0, 0, 51),  //yellow
            (51, 0, 51), //green
            (51, 0, 0),  //turquoise
            (51, 25, 0), //skyBlue
            (51, 51, 0), //blue
            (25, 51, 0), //violet
            (0, 51, 0),  //fuchsia
            (0, 51, 25), //pink
            (33, 33, 33) //gray
        ]
    }
}
//MARK: PickerStyle and ColorLabelBackground
extension CustomColorPicker {
    
    enum PickerStyle {
        case carousel
        case grid
    }
    
    enum ColorLabelBackground {
        case grid
        case gradient
    }
}
//MARK: Initializers
extension CustomColorPicker {
    
    init(selection: Binding<Color>,
         minBrightness: CGFloat = (1/255)/10,
         maxBrightness: CGFloat = 1,
         minOpacity: CGFloat = (1/255)/10,
         maxOpacity: CGFloat = 1,
         minHSBAUnit: CGFloat = (1/255)/10,
         supportsOpacity: Bool = true,
         supportsBrightness: Bool = true,
         pickerStyle: CustomColorPicker.PickerStyle = .carousel,
         colorLabelBackground: CustomColorPicker.ColorLabelBackground = .grid)
    {
        self._selectedColor = selection
        
        self.minBrightness = minBrightness
        self.maxBrightness = maxBrightness
        
        self.minOpacity = minOpacity
        self.maxOpacity = maxOpacity
        
        self.minHSBAUnit = minHSBAUnit
        
        self.supportsBrightness = supportsBrightness
        self.supportsOpacity = supportsOpacity
        
        self.pickerStyle = pickerStyle
        self.colorLabelBackground = colorLabelBackground
    }
}

extension CustomColorPicker {
    
    init(selection: Binding<Color>,
         minBrightness: CGFloat,
         maxBrightness: CGFloat,
         minOpacity: CGFloat,
         maxOpacity: CGFloat,
         minHSBAUnit: CGFloat)
    {
        self._selectedColor = selection
        
        self.minBrightness = minBrightness
        self.maxBrightness = maxBrightness
        
        self.minOpacity = minOpacity
        self.maxOpacity = maxOpacity
        
        self.minHSBAUnit = minHSBAUnit
        
        self.supportsBrightness = true
        self.supportsOpacity = true
        
        self.pickerStyle = .carousel
        self.colorLabelBackground = .grid
    }
}

extension CustomColorPicker {
    
    init(selection: Binding<Color>,
         supportsOpacity: Bool,
         supportsBrightness: Bool)
    {
        self._selectedColor = selection
        
        self.minBrightness = (1/255)/10
        self.maxBrightness = 1
        
        self.minOpacity = (1/255)/10
        self.maxOpacity = 1
        
        self.minHSBAUnit = 1/255
        
        self.supportsBrightness = supportsBrightness
        self.supportsOpacity = supportsOpacity
        
        self.pickerStyle = .carousel
        self.colorLabelBackground = .grid
    }
}


extension CustomColorPicker {
    
    init(selection: Binding<Color>,
         pickerStyle: CustomColorPicker.PickerStyle,
         colorLabelBackground: CustomColorPicker.ColorLabelBackground)
    {
        self._selectedColor = selection
        
        self.minBrightness = (1/255)/10
        self.maxBrightness = 1
        
        self.minOpacity = (1/255)/10
        self.maxOpacity = 1
        
        self.minHSBAUnit = 1/255
        
        self.supportsBrightness = true
        self.supportsOpacity = true
        
        self.pickerStyle = pickerStyle
        self.colorLabelBackground = colorLabelBackground
    }
}

struct CustomColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomColorPicker(selection: .constant(.red), pickerStyle: .grid, colorLabelBackground: .gradient)
    }
}


