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
import xpath.token.BeginFunctionCallToken;


class BeginFunctionCallTokenizer extends TokenTokenizer {
	
	private static var instance:BeginFunctionCallTokenizer;
	
	
	public static function getInstance () :BeginFunctionCallTokenizer {
		if (instance == null) instance = new BeginFunctionCallTokenizer();
		return instance;
	}
	
	private function new () {
	}
	
	override public function tokenize (state:TokenizeState) :TokenizeState {
		var resultState:TokenizeState = state.newWorkingCopy();
		var pos:Int = resultState.pos;
		
		// check for NCName
		var nameStartPos:Int = pos;
		var charCode:Int = resultState.xpathStr.charCodeAt(pos);
		if (
			(charCode < 65 || charCode > 90) &&
			(charCode < 97 || charCode > 122) &&
			charCode < 128 && charCode != 95
		) {
			// fail
			return resultState;
		}
		do {
			charCode = resultState.xpathStr.charCodeAt(++pos);
		} while (
			(charCode > 47 && charCode < 58) ||
			(charCode > 64 && charCode < 91) ||
			(charCode > 96 && charCode < 123) ||
			charCode > 127 || charCode == 46 ||
			charCode == 45 || charCode == 95
		);
		
		// check for colon
		if (charCode == 58) {
			// check for NCName
			charCode = resultState.xpathStr.charCodeAt(++pos);
			if (
				(charCode < 65 || charCode > 90) &&
				(charCode < 97 || charCode > 122) &&
				charCode < 128 && charCode != 95
			) {
				// fail
				return resultState;
			}
			do {
				charCode = resultState.xpathStr.charCodeAt(++pos);
			} while (
				(charCode > 47 && charCode < 58) ||
				(charCode > 64 && charCode < 91) ||
				(charCode > 96 && charCode < 123) ||
				charCode > 127 || charCode == 46 ||
				charCode == 45 || charCode == 95
			);
		}
		
		var nameLength:Int = pos - nameStartPos;
		pos = skipWhitespace(resultState.xpathStr, pos);
		
		// check name
		var name:String = resultState.xpathStr.substr(nameStartPos, nameLength);
		if (name == "comment" || name == "text" || name == "node" || name == "processing-instruction") {
			// comment(), text(), node() and processing-instruction() must not parse as functions
			// fail
			return resultState;
		}
		
		// check for open parenthesis
		if (resultState.xpathStr.charAt(pos) != "(") {
			// fail
			return resultState;
		}
		
		// succeed
		resultState.result = [cast(new BeginFunctionCallToken(name), Token)];
		resultState.pos = skipWhitespace(resultState.xpathStr, pos+1);
		return resultState;
	}
	
}