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
import xpath.XPathEvaluationException;
import xpath.type.XPathBoolean;
import xpath.type.XPathNumber;
import xpath.type.XPathString;


/** Abstract class for data types used within XPath queries. */
class XPathValue {
	
	/** Name of the data type */
	public var typeName(default, null):String;
	
	/** Abstract API provided by descendant class */
	public var xPathValueApi(default, null):XPathValueApi;
	
	
	private function new (api:XPathValueApi) {
		if (api == null) {
			throw "Descendant class must provide XPathValueApi";
		}
		
		this.xPathValueApi = api;
	}
	
	/** Converts this object to an XPathBoolean according to the definition of
	 * the boolean() function in the XPath specification. */
	public function getXPathBoolean () :XPathBoolean {
		return new XPathBoolean(this.xPathValueApi.getBool());
	}
	
	/** Converts this object to an XPathNumber according to the definition of
	 * the number() function in the XPath specification. */
	public function getXPathNumber () :XPathNumber {
		return new XPathNumber(this.xPathValueApi.getFloat());
	}
	
	/** Converts this object to an XPathString according to the definition of
	 * the string() function in the XPath specification. */
	public function getXPathString () :XPathString {
		return new XPathString(this.xPathValueApi.getString());
	}
	
	/** Performs the boolean and operation as defined by the XPath specification. */
	public function and (rightOperand:XPathValue) :XPathBoolean {
		return new XPathBoolean(this.xPathValueApi.getBool() && rightOperand.xPathValueApi.getBool());
	}
	
	/** Performs the boolean or operation as defined by the XPath specification. */
	public function or (rightOperand:XPathValue) :XPathBoolean {
		return new XPathBoolean(this.xPathValueApi.getBool() || rightOperand.xPathValueApi.getBool());
	}
	
	/** Performs the addition operation as defined by the XPath specification. */
	public function plus (rightOperand:XPathValue) :XPathNumber {
		return new XPathNumber(this.xPathValueApi.getFloat() + rightOperand.xPathValueApi.getFloat());
	}
	
	/** Performs the subtraction operation as defined by the XPath specification. */
	public function minus (rightOperand:XPathValue) :XPathNumber {
		return new XPathNumber(this.xPathValueApi.getFloat() - rightOperand.xPathValueApi.getFloat());
	}
	
	/** Peforms the multiplication operation as defined by the XPath specification. */
	public function multiply (rightOperand:XPathValue) :XPathNumber {
		return new XPathNumber(this.xPathValueApi.getFloat() * rightOperand.xPathValueApi.getFloat());
	}
	
	/** Performs the division operation as defined by the XPath specification. */
	public function divide (rightOperand:XPathValue) :XPathNumber {
		return new XPathNumber(this.xPathValueApi.getFloat() / rightOperand.xPathValueApi.getFloat());
	}
	
	/** Performs the modulo operation as defined by the XPath specification. */
	public function modulo (rightOperand:XPathValue) :XPathNumber {
		return new XPathNumber(this.xPathValueApi.getFloat() % rightOperand.xPathValueApi.getFloat());
	}
	
	/** Performs the union operation as defined by the XPath specification.
	 * Throws XPathEvaluationException if either operand is not an XPathNodeSet */
	public function union (rightOperand:XPathValue) :XPathNodeSet {
		throw new XPathEvaluationException(
			"can't compute union of " + this.typeName + " and " + rightOperand.typeName
		);
		return null;
	}
	
}

/** Abstract API provided by descendants of XPathValue. */
typedef XPathValueApi = {
	
	/** Gets the boolean value of this object as per the boolean() function
	 * defined by the XPath specification. */
	public function getBool () :Bool;
	
	/** Gets the numeric value of this object as per the number() function
	 * defined by the XPath specification. */
	public function getFloat () :Float;
	
	/** Gets the string value of this object as per the string() function
	 * defined by the XPath specification. */
	public function getString () :String;
	
	/** Performs the equality operation as defined by the XPath specification. */
	public function equals (rightOperand:XPathValue) :XPathBoolean;
	
	/** Performs the inequality operation as defined by the XPath specification. */
	public function notEqual (rightOperand:XPathValue) :XPathBoolean;
	
	/** Performs the less-than-or-equal operation as defined by the XPath
	 * specification. */
	public function lessThanOrEqual (rightOperand:XPathValue) :XPathBoolean;
	
	/** Performs the greater-than-or-equal operation as defined by the XPath
	 * specification. */
	public function greaterThanOrEqual (rightOperand:XPathValue) :XPathBoolean;
	
	/** Performs the less-than operation as defined by the XPath specification. */
	public function lessThan (rightOperand:XPathValue) :XPathBoolean;
	
	/** Performs the greater-than operation as defined by the XPath specification. */
	public function greaterThan (rightOperand:XPathValue) :XPathBoolean;
	
}
