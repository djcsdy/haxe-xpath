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
import xpath.token.NameTestToken;


class NameTestTokenizer extends TokenTokenizer {
	
	private static var instance:NameTestTokenizer;
	
	
	public static function getInstance () :NameTestTokenizer {
		if (instance == null) instance = new NameTestTokenizer();
		return instance;
	}
	
	private function new () {
	}
		
	override public function tokenize (state:TokenizeState) {
		var resultState:TokenizeState = state.newWorkingCopy();
		var pos:Int = resultState.pos;
		
		// check for wildcard
		if (resultState.xpathStr.charAt(pos) == "*") {
			var name:String = "*";
			resultState.result = [cast(new NameTestToken(name), Token)];
			resultState.pos = skipWhitespace(resultState.xpathStr, pos+1);
			return resultState;
		}
		
		// check for NCName
		var nameStartPos:Int = pos;
		var charCode:Int = resultState.xpathStr.charCodeAt(pos);
		if (charCode == null || (
			(charCode < 65 || charCode > 90) &&
			(charCode < 97 || charCode > 122) &&
			charCode < 128 && charCode != 95
		)) {
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
		if (charCode != 58) {
			var name:String = resultState.xpathStr.substr(nameStartPos, pos - nameStartPos);
			resultState.result = [cast(new NameTestToken(name), Token)];
			resultState.pos = skipWhitespace(resultState.xpathStr, pos);
			return resultState;
		}
		
		// check for wildcard
		if (resultState.xpathStr.charAt(++pos) == "*") {
			var name:String = resultState.xpathStr.substr(nameStartPos, pos + 1 - nameStartPos);
			resultState.result = [cast(new NameTestToken(name), Token)];
			resultState.pos = skipWhitespace(resultState.xpathStr, pos+1);
			return resultState;
		}
		
		// check for NCName
		charCode = resultState.xpathStr.charCodeAt(pos);
		if (charCode == null || (
			(charCode < 65 || charCode > 90) &&
			(charCode < 97 || charCode > 122) &&
			charCode < 128 && charCode != 95
		)) {
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
		
		var name:String = resultState.xpathStr.substr(nameStartPos, pos - nameStartPos);
		resultState.result = [cast(new NameTestToken(name), Token)];
		resultState.pos = skipWhitespace(resultState.xpathStr, pos);
		return resultState;
	}
	
}