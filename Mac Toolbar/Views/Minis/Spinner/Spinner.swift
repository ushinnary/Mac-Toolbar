//
//  Spinner.swift
//  Mac Toolbar
//
//  Created by Ushinnary on 02/06/2021.
//
import SwiftUI


struct Spinner: View {
	let rotationTime: Double = 0.75
	let animationTime: Double = 1.9 // Sum of all animation times
	let fullRotation: Angle = .degrees(360)
	static let initialDegree: Angle = .degrees(270)
	var lineWidth: CGFloat = CGFloat(3)
	var size: CGFloat = 50
	
	@State var spinnerStart: CGFloat = 0.0
	@State var spinnerEndS1: CGFloat = 0.03
	@State var spinnerEndS2S3: CGFloat = 0.03
	
	@State var rotationDegreeS1 = initialDegree
	@State var rotationDegreeS2 = initialDegree
	@State var rotationDegreeS3 = initialDegree
	
	var body: some View {
		ZStack {
			ZStack {
				// S3
				SpinnerCircle(start: spinnerStart, end: spinnerEndS2S3, rotation: rotationDegreeS3, color: .purple, lineWidth: lineWidth)
				
				// S2
				SpinnerCircle(start: spinnerStart, end: spinnerEndS2S3, rotation: rotationDegreeS2, color: .pink, lineWidth: lineWidth)
				
				// S1
				SpinnerCircle(start: spinnerStart, end: spinnerEndS1, rotation: rotationDegreeS1, color: .blue, lineWidth: lineWidth)
				
			}.frame(width: size, height: size)
		}
		.onAppear() {
			self.animateSpinners()
			Timer.scheduledTimer(withTimeInterval: animationTime, repeats: true) { (mainTimer) in
				self.animateSpinners()
			}
		}
	}
	
	// MARK: Animation methods
	func animateSpinner(with duration: Double, completion: @escaping (() -> Void)) {
		Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
			withAnimation(Animation.easeInOut(duration: self.rotationTime)) {
				completion()
			}
		}
	}
	
	func animateSpinners() {
		let doubledRotationTime = (rotationTime * 2)
		animateSpinner(with: rotationTime) { self.spinnerEndS1 = 1.0 }
		
		animateSpinner(with: doubledRotationTime - 0.025) {
			self.rotationDegreeS1 += fullRotation
			self.spinnerEndS2S3 = 0.8
		}
		
		animateSpinner(with: doubledRotationTime) {
			self.spinnerEndS1 = 0.03
			self.spinnerEndS2S3 = 0.03
		}
		
		animateSpinner(with: doubledRotationTime + 0.0525) { self.rotationDegreeS2 += fullRotation }
		
		animateSpinner(with: doubledRotationTime + 0.225) { self.rotationDegreeS3 += fullRotation }
	}
}

// MARK: SpinnerCircle
struct SpinnerCircle: View {
	var start: CGFloat
	var end: CGFloat
	var rotation: Angle
	var color: Color
	var lineWidth: CGFloat
	
	var body: some View {
		Circle()
			.trim(from: start, to: end)
			.stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
			.fill(color)
			.rotationEffect(rotation)
			.padding(5)
	}
}

struct Spinner_Previews: PreviewProvider {
	static var previews: some View {
		ZStack {
			Spinner()
		}
	}
}
