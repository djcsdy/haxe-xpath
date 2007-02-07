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
import xpath.type.XPathNumber;
import xpath.type.XPathBoolean;


/** Class implementing the string data type used by XPath queries. */
class XPathString extends XPathNumber {
	
	private var string:String;
	
	
	/** Constructs a new XPathString with the specified value. */
	public function new (?string:String) {
		super();
		typeName = "string";
		if (string == null) this.string = "";
		else this.string = string;
	}
	
	/** Gets the boolean value of this XPathString as per the boolean() function
	 * defined by the XPath specification. The result is true if and only if the
	 * length of the XPathString is non-zero. */
	override public function getBool () :Bool {
		return string.length != 0;
	}
	
	/** Gets the numeric value of this XPathString as per the number() function
	 * defined by the XPath specification. If the string consists of optional 
	 * whitespace, followed by an optional minus sign, followed by a Number as
	 * defined in the XPath grammar, followed by optional whitespace, then the
	 * string is converted to the IEEE 754 number that is nearest (according to
	 * the IEEE 754 round-to-nearest rule) to the mathematical value represented
	 * by the string. Otherwise, the string is converted to NaN. */
	override public function getFloat () :Float {
		return Std.parseFloat(StringTools.trim(string));
	}
	
	/** Gets the string value of this object. */
	override public function getString () :String {
		return string;
	}
	
	/** Converts this object to an XPathString according to the definition of
	 * the string() function in the XPath specification. */
	override public function getXPathString () :XPathString {
		return this;
	}
	
	/** Performs the equality operation as defined by the XPath specification. */
	override public function equals (rightOperand:XPathValue) :XPathBoolean {
		if (Std.is(rightOperand, XPathNodeSet)) {
			var nodes:Array<Xml> = cast(rightOperand, XPathNodeSet).getNodes();
			for (node in nodes) {
				if (this.getString() == node.getStringValue()) return new XPathBoolean(true);
			}
			return new XPathBoolean(false);
		} else if (Std.is(rightOperand, XPathNumber)) {
			return new XPathBoolean(this.xPathValueApi.getString() == rightOperand.xPathValueApi.getString());
		} else {
			return super.equals(rightOperand);
		}
	}
	
	/** Performs the inequality operation as defined by the XPath specification. */
	override public function notEqual (rightOperand:XPathValue) :XPathBoolean {
		if (Std.is(rightOperand, XPathNodeSet)) {
			var nodes:Array<Xml> = cast(rightOperand, XPathNodeSet).getNodes();
			for (node in nodes) {
				if (this.getString() != node.getStringValue()) return new XPathBoolean(true);
			}
			return new XPathBoolean(false);
		} else if (Std.is(rightOperand, XPathString)) {
			return new XPathBoolean(this.xPathValueApi.getString() != rightOperand.xPathValueApi.getString());
		} else {
			return super.notEqual(rightOperand);
		}
	}
	
}