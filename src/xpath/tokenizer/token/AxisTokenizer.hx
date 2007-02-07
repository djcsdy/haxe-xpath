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


package xpath.tokenizer.token;
import xpath.tokenizer.token.TokenTokenizer;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizeState;
import xpath.token.Token;
import xpath.token.AxisToken;


class AxisTokenizer extends TokenTokenizer {

	private static var instance:AxisTokenizer;
	
	private var axisNames:Array<String>;
	
	private var axisNameToAxisEnum:Hash<AxisEnum>;
	

	public static function getInstance () :AxisTokenizer {
		if (instance == null) instance = new AxisTokenizer();
		return instance;
	}
	
	
	private function new () {
		axisNameToAxisEnum = new Hash<AxisEnum>();
		axisNameToAxisEnum.set("ancestor", Ancestor);
		axisNameToAxisEnum.set("ancestor-or-self", AncestorOrSelf);
		axisNameToAxisEnum.set("attribute", Attribute);
		axisNameToAxisEnum.set("child", Child);
		axisNameToAxisEnum.set("descendant", Descendant);
		axisNameToAxisEnum.set("descendant-or-self", DescendantOrSelf);
		axisNameToAxisEnum.set("following", Following);
		axisNameToAxisEnum.set("following-sibling", FollowingSibling);
		axisNameToAxisEnum.set("namespace", Namespace);
		axisNameToAxisEnum.set("parent", Parent);
		axisNameToAxisEnum.set("preceding", Preceding);
		axisNameToAxisEnum.set("preceding-sibling", PrecedingSibling);
		axisNameToAxisEnum.set("self", Self);
		
		axisNames = new Array<String>();
		for (axisName in axisNameToAxisEnum.keys()) {
			axisNames.push(axisName);
		}
		
		// sort names by length, longest first
		axisNames.sort(function (x:String, y:String) {
			return y.length - x.length;
		});
	}

	override public function tokenize (state:TokenizeState) :TokenizeState {
		var resultState:TokenizeState = state.newWorkingCopy();
		var pos:Int = resultState.pos;
		
		// check for axis name
		var axisEnum:AxisEnum;
		for (axisName in axisNames) {
			if (resultState.xpathStr.substr(pos, axisName.length) == axisName) {
				pos = skipWhitespace(resultState.xpathStr, pos + axisName.length);
				
				// check for axis operator "::"
				if (resultState.xpathStr.substr(pos, 2) == "::") {
					// succeed
					pos += 2;
					axisEnum = axisNameToAxisEnum.get(axisName);
				} else {
					pos = state.pos;
					axisEnum = Child;
				}
				break;
			}
		}
		
		if (axisEnum == null) {
			// check for short names
			if (resultState.xpathStr.charAt(pos) == "@") {
				axisEnum = Attribute;
				++pos;
			} else {
				axisEnum = Child;
			}
		}
			
		resultState.pos = skipWhitespace(resultState.xpathStr, pos);
		resultState.result = [cast(new AxisToken(axisEnum), Token)];
		
		return resultState;
	}
	
}