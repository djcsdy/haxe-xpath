/* haXe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
 * Dedicated to the Public Domain
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS 
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
import xpath.type.XPathNumber;


/** Class implementing the boolean data type used by XPath queries. */
class XPathBoolean extends XPathValue {
	
	private var bool:Bool;
	
	
	/** Constructs a new XPathBoolean with the specified value. */
	public function new (?bool:Bool) {
		super(this);
		typeName = "boolean";
		if (bool == null) this.bool = false;
		else this.bool = bool;
	}
	
	/** Gets the boolean value of this XPathBoolean. */
	public function getBool () :Bool {
		return bool;
	}
	
	/** Gets the numeric value of this XPathBoolean as per the number() function
	 * defined by the XPath specification. If the boolean is true, it is converted
	 * to 1; otherwise it is converted to 0. */
	public function getFloat () :Float {
		if (bool) return 1;
		else return 0;
	}
	
	/** Gets the string value of this XPathBoolean as per the string() function
	 * defined by the XPath specification. If the boolean is true, it is converted
	 * to the string "true"; otherwise it is converted to the string "false". */
	public function getString () :String {
		if (bool) return "true";
		else return "false";
	}
	
	/** Converts this object to an XPathBoolean according to the definition of
	 * the boolean() function in the XPath specification. */
	override public function getXPathBoolean () :XPathBoolean {
		return this;
	}
	
	/** Performs the equality operation as defined by the XPath specification. */
	public function equals (rightOperand:XPathValue) :XPathBoolean {
		return new XPathBoolean(this.xPathValueApi.getBool() == rightOperand.xPathValueApi.getBool());
	}
	
	/** Performs the inequality operation as defined by the XPath specification. */
	public function notEqual (rightOperand:XPathValue) :XPathBoolean {
		return new XPathBoolean(this.xPathValueApi.getBool() != rightOperand.xPathValueApi.getBool());
	}
	
	/** Performs the less-than-or-equal operation as defined by the XPath
	 * specification. */
	public function lessThanOrEqual (rightOperand:XPathValue) :XPathBoolean {
		if (Std.is(rightOperand, XPathNodeSet)) {
			return new XPathBoolean(!this.xPathValueApi.getBool() || rightOperand.xPathValueApi.getBool());
		} else {
			return new XPathBoolean(this.xPathValueApi.getFloat() <= rightOperand.xPathValueApi.getFloat());
		}
	}
	
	/** Performs the greater-than-or-equal operation as defined by the XPath
	 * specification. */
	public function greaterThanOrEqual (rightOperand:XPathValue) :XPathBoolean {
		if (Std.is(rightOperand, XPathNodeSet)) {
			return new XPathBoolean(this.xPathValueApi.getBool() || !rightOperand.xPathValueApi.getBool());
		} else {
			return new XPathBoolean(this.xPathValueApi.getFloat() >= rightOperand.xPathValueApi.getFloat());
		}
	}
	
	/** Performs the less-than operation as defined by the XPath specification. */
	public function lessThan (rightOperand:XPathValue) :XPathBoolean {
		if (Std.is(rightOperand, XPathNodeSet)) {
			return new XPathBoolean(!this.xPathValueApi.getBool() && rightOperand.xPathValueApi.getBool());
		} else {
			return new XPathBoolean(this.xPathValueApi.getFloat() < rightOperand.xPathValueApi.getFloat());
		}
	}
	
	/** Performs the greater-than operation as defined by the XPath specification. */
	public function greaterThan (rightOperand:XPathValue) :XPathBoolean {
		if (Std.is(rightOperand, XPathNodeSet)) {
			return new XPathBoolean(this.xPathValueApi.getBool() && !rightOperand.xPathValueApi.getBool());
		} else {
			return new XPathBoolean(this.xPathValueApi.getFloat() > rightOperand.xPathValueApi.getFloat());
		}
	}
	
}