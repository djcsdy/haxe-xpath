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


package xpath.tokenizer.token;
import xpath.tokenizer.token.TokenTokenizer;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizeState;
import xpath.token.Token;
import xpath.token.TypeTestToken;


class TypeTestTokenizer extends TokenTokenizer {
	
	private static var instance:TypeTestTokenizer;
	
	private var typeNames:Array<String>;
	
	private var typeNameToTypeTestEnum:Hash<TypeTestEnum>;
	
	
	public static function getInstance () :TypeTestTokenizer {
		if (instance == null) instance = new TypeTestTokenizer();
		return instance;
	}
	
	private function new () {
		typeNameToTypeTestEnum = new Hash<TypeTestEnum>();
		typeNameToTypeTestEnum.set("comment", Comment);
		typeNameToTypeTestEnum.set("text", Text);
		typeNameToTypeTestEnum.set("node", Node);
		
		typeNames = new Array<String>();
		for (typeName in typeNameToTypeTestEnum.keys()) {
			typeNames.push(typeName);
		}
		
		// sort type names by length, longest first
		typeNames.sort(function (x:String, y:String) {
			return y.length - x.length;
		});
	}
	
	override public function tokenize (state:TokenizeState) :TokenizeState {
		var resultState:TokenizeState = state.newWorkingCopy();
		var pos:Int = resultState.pos;
		
		// check for type name
		for (typeName in typeNames) {
			if (resultState.xpathStr.substr(pos, typeName.length) == typeName) {
				pos = skipWhitespace(resultState.xpathStr, pos + typeName.length);
				if (resultState.xpathStr.charAt(pos) != "(") return resultState;
				pos = skipWhitespace(resultState.xpathStr, pos+1);
				if (resultState.xpathStr.charAt(pos) != ")") return resultState;
				
				var type:TypeTestEnum = typeNameToTypeTestEnum.get(typeName);
				resultState.result = [cast(new TypeTestToken(type), Token)];
				resultState.pos = skipWhitespace(resultState.xpathStr, pos+1);
				
				return resultState;
			}
		}
		
		// fail
		return resultState;
	}
	
}