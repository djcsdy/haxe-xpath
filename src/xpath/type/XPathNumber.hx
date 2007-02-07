/* haXe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
 * Dedicated to the Public Domain
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS AND ANY EXPRESS 
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */


package xpath.type;
import dcxml.Xml;
import xpath.type.XPathValue;
import xpath.type.XPathNodeSet;
import xpath.type.XPathString;
import xpath.type.XPathBoolean;


/** Class implementing the number data type used by XPath queries. */
class XPathNumber extends XPathBoolean {
	
	private var number:Float;
	
	
	/** Constructs a new XPathNumber with the specified value. */
	public function new (?number:Float) {
		super();
		typeName = "number";
		if (number == null) this.number = 0;
		else this.number = number;
	}
	
	/** Gets the boolean value of this XPathNumber as per the boolean() function
	 * defined by the XPath specification. The number is true if and only if
	 * it is neither positive or negative zero, nor NaN. */
	override public function getBool () :Bool {
		return (number!=0 && !Math.isNaN(number));
	}
	
	/** Gets the numeric value of this XPathNumber. */
	override public function getFloat () :Float {
		return number;
	}
	
	/** Gets the string value of this XPathNumber as per the string() function
	 * defined by the XPath specification:<ul>
	 * <li>NaN is converted to the string "NaN"
	 * <li>+0 is converted to the string "0"
	 * <li>-0 is converted to the string "-0"
	 * <li>+infinity is converted to the string "Infinity"
	 * <li>-infinity is converted to the string "-Infinity"
	 * <li>if the number is an integer, the number is represented in decimal
	 *     form as a Number (as defined by the XPath grammar) with no decimal
	 *     point and no leading zeros, preceded by a minus sign if the number
	 *     is negative
	 * <li>otherwise, the number is represented in decimal form as a Number
	 *     (as defined by the XPath grammar) including a decimal point with
	 *     at least one digit before the decimal point and at least one
	 *     digit after the decimal point, preceded by a minus sign if the
	 *     number is negative; there will be no leading zeros before the
	 *     decimal point apart possibly from the one required digit
	 *     immediately before the decimal point; beyond the required digit
	 *     after the decimal point there will be as many, but only as many,
	 *     more digits as are needed to uniquely distinguish the number from
	 *     all other IEEE 754 numeric values.</ul> */
	override public function getString () :String {
		var string:String = Std.string(number);

		var eIndex:Int = string.indexOf("e");
		if (eIndex > -1) {
			var digits = string.charAt(0) + string.substr(2, eIndex-2);
			if (string.charAt(eIndex+1) == "-") {
				var exponent:Int = Std.parseInt(string.substr(eIndex+2));
				string = "0.";
				for (i in 1...exponent) {
					string += "0";
				}
				string += digits;
			} else {
				var exponent:Int = Std.parseInt(string.substr(eIndex+1));
				if (digits.length <= exponent+1) {
					string = digits;
					while (string.length <= exponent) {
						string += "0";
					}
				} else {
					string = digits.substr(0, exponent+1) + "." + digits.substr(exponent+1);
				}
			}
		}
		
		return string;
	}
	
	/** Performs the division operation as defined by the XPath specification. */
	override public function getXPathNumber () :XPathNumber {
		return this;
	}
	
	/** Performs the equality operation as defined by the XPath specification. */
	override public function equals (rightOperand:XPathValue) :XPathBoolean {
		if (Std.is(rightOperand, XPathNodeSet)) {
			var nodes:Array<Xml> = cast(rightOperand, XPathNodeSet).getNodes();
			for (node in nodes) {
				var nodeString:String = StringTools.trim(node.getStringValue());
				if (this.getFloat() == Std.parseFloat(nodeString)) return new XPathBoolean(true);
			}
			return new XPathBoolean(false);
		} else if (Std.is(rightOperand, XPathNumber)) {
			return new XPathBoolean(this.xPathValueApi.getFloat() == rightOperand.xPathValueApi.getFloat());
		} else {
			return super.equals(rightOperand);
		}
	}
	
	/** Performs the inequality operation as defined by the XPath specification. */
	override public function notEqual (rightOperand:XPathValue) :XPathBoolean {
		if (Std.is(rightOperand, XPathNodeSet)) {
			var nodes:Array<Xml> = cast(rightOperand, XPathNodeSet).getNodes();
			for (node in nodes) {
				var nodeString:String = StringTools.trim(node.getStringValue());
				if (this.getFloat() != Std.parseFloat(nodeString)) return new XPathBoolean(true);
			}
			return new XPathBoolean(false);
		} else if (Std.is(rightOperand, XPathNumber)) {
			return new XPathBoolean(this.xPathValueApi.getFloat() != rightOperand.xPathValueApi.getFloat());
		} else {
			return super.notEqual(rightOperand);
		}
	}
	
	/** Performs the less-than-or-equal operation as defined by the XPath
	 * specification. */
	override public function lessThanOrEqual (rightOperand:XPathValue) :XPathBoolean {
		if (Std.is(rightOperand, XPathNodeSet)) {
			var nodes:Array<Xml> = cast(rightOperand, XPathNodeSet).getNodes();
			for (node in nodes) {
				var nodeString:String = StringTools.trim(node.getStringValue());
				if (this.getFloat() <= Std.parseFloat(nodeString)) return new XPathBoolean(true);
			}
			return new XPathBoolean(false);
		} else {
			return new XPathBoolean(this.xPathValueApi.getFloat() <= rightOperand.xPathValueApi.getFloat());
		}
	}
	
	/** Performs the greater-than-or-equal operation as defined by the XPath
	 * specification. */
	override public function greaterThanOrEqual (rightOperand:XPathValue) :XPathBoolean {
		if (Std.is(rightOperand, XPathNodeSet)) {
			var nodes:Array<Xml> = cast(rightOperand, XPathNodeSet).getNodes();
			for (node in nodes) {
				var nodeString:String = StringTools.trim(node.getStringValue());
				if (this.getFloat() >= Std.parseFloat(nodeString)) return new XPathBoolean(true);
			}
			return new XPathBoolean(false);
		} else {
			return new XPathBoolean(this.xPathValueApi.getFloat() >= rightOperand.xPathValueApi.getFloat());
		}
	}
	
	/** Performs the less-than operation as defined by the XPath specification. */
	override public function lessThan (rightOperand:XPathValue) :XPathBoolean {
		if (Std.is(rightOperand, XPathNodeSet)) {
			var nodes:Array<Xml> = cast(rightOperand, XPathNodeSet).getNodes();
			for (node in nodes) {
				var nodeString:String = StringTools.trim(node.getStringValue());
				if (this.getFloat() < Std.parseFloat(nodeString)) return new XPathBoolean(true);
			}
			return new XPathBoolean(false);
		} else {
			return new XPathBoolean(this.xPathValueApi.getFloat() < rightOperand.xPathValueApi.getFloat());
		}
	}
	
	/** Performs the greater-than operation as defined by the XPath specification. */
	override public function greaterThan (rightOperand:XPathValue) :XPathBoolean {
		if (Std.is(rightOperand, XPathNodeSet)) {
			var nodes:Array<Xml> = cast(rightOperand, XPathNodeSet).getNodes();
			for (node in nodes) {
				var nodeString:String  = StringTools.trim(node.getStringValue());
				if (this.getFloat() > Std.parseFloat(nodeString)) return new XPathBoolean(true);
			}
			return new XPathBoolean(false);
		} else {
			return new XPathBoolean(this.xPathValueApi.getFloat() > rightOperand.xPathValueApi.getFloat());
		}
	}
	
}