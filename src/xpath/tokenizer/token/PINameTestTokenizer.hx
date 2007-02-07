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
import xpath.token.PINameTestToken;


class PINameTestTokenizer extends TokenTokenizer {
	
	private static var instance:PINameTestTokenizer;
	
	
	public static function getInstance () :PINameTestTokenizer {
		if (instance == null) instance = new PINameTestTokenizer();
		return instance;
	}
	
	private function new () {
	}

	override public function tokenize (state:TokenizeState) :TokenizeState {
		var resultState:TokenizeState = state.newWorkingCopy();
		var pos:Int = resultState.pos;
		
		// check for "processing-instruction"
		if (resultState.xpathStr.substr(pos, 22) != "processing-instruction") {
			// fail
			return resultState;
		}
		
		pos = skipWhitespace(resultState.xpathStr, pos+22);
		if (resultState.xpathStr.charAt(pos) != "(") return resultState;
		pos = skipWhitespace(resultState.xpathStr, pos+1);
		
		// check for argument
		var name:String;
		var quote:String = resultState.xpathStr.charAt(pos);
		if (quote == "'" || quote == '"') {
			var nameStartPos:Int = pos+1;
			
			var c:String;
			do {
				c = resultState.xpathStr.charAt(++pos);
			} while (c != quote && pos < resultState.xpathStr.length-1);
			
			if (c == quote) {
				name = resultState.xpathStr.substr(nameStartPos, pos - nameStartPos);
			} else {
				// reached the end of the xpathStr without the argument string ever terminating
				// fail
				return resultState;
			}
			
			pos = skipWhitespace(resultState.xpathStr, pos+1);
		} else {
			name = null; // any processing instruction
		}
		
		if (resultState.xpathStr.charAt(pos) == ")") {
			resultState.result = [cast(new PINameTestToken(name), Token)];
			resultState.pos = skipWhitespace(resultState.xpathStr, pos+1);
		} // else fail
		
		return resultState;
	}
	
}