/* Copyright 2022 The StableHLO Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

#ifndef STABLHLO_REFERENCE_ELEMENT_H
#define STABLHLO_REFERENCE_ELEMENT_H

#include <complex>
#include <variant>

#include "llvm/ADT/APFloat.h"
#include "llvm/Support/raw_ostream.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/Types.h"

namespace mlir {
namespace stablehlo {

/// Class to represent an element of a tensor. An Element object stores the
/// element type of the tensor and, depending on that element type, a constant
/// value of type integer, floating-paint, or complex type.
class Element {
 public:
  /// \name Constructors
  /// @{
  Element(Type type, APInt value) : type_(type), value_(value) {}
  Element(Type type, APFloat value) : type_(type), value_(value) {}
  Element(Type type, std::complex<APFloat> value)
      : type_(type), value_(std::make_pair(value.real(), value.imag())) {}

  Element(const Element &other) = default;
  /// @}

  /// Assignment operator.
  Element &operator=(const Element &other) = default;

  /// Returns type of the Element object.
  Type getType() const { return type_; }

  /// Returns the underlying integer value stored in an Element object with
  /// integer type.
  APInt getIntegerValue() const;

  /// Returns the underlying floating-point value stored in an Element object
  /// with floating-point type.
  APFloat getFloatValue() const;

  /// Returns the underlying complex value stored in an Element object with
  /// complex type.
  std::complex<APFloat> getComplexValue() const;

  /// Overloaded + operator.
  Element operator+(const Element &other) const;

  /// Overloaded negate operator.
  Element operator-() const;

  /// Overloaded - operator.
  Element operator-(const Element &other) const;

  /// Print utilities for Element objects.
  void print(raw_ostream &os) const;

  /// Print utilities for Element objects.
  void dump() const;

 private:
  Type type_;
  std::variant<APInt, APFloat, std::pair<APFloat, APFloat>> value_;
};

/// Returns element-wise ceil of Element object.
Element ceil(const Element &e);

/// Returns element-wise cosine of Element object.
Element cosine(const Element &e);

/// Returns element-wise floor of Element object.
Element floor(const Element &e);

/// Returns element-wise sine of Element object.
Element sine(const Element &e);

/// Returns element-wise tanh of Element object.
Element tanh(const Element &e);

/// Print utilities for Element objects.
inline raw_ostream &operator<<(raw_ostream &os, Element element) {
  element.print(os);
  return os;
}

/// Check if the type 'type' comfirms with what is supported in the StableHLO
/// spec.
bool isSupportedUnsignedIntegerType(Type type);
bool isSupportedSignedIntegerType(Type type);
bool isSupportedIntegerType(Type type);
bool isSupportedFloatType(Type type);
bool isSupportedComplexType(Type type);

}  // namespace stablehlo
}  // namespace mlir

#endif  // STABLHLO_REFERENCE_ELEMENT_H