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
import xpath.token.LiteralToken;


class LiteralTokenizer extends TokenTokenizer {
	
	private static var instance:LiteralTokenizer;
	
	
	public static function getInstance () :LiteralTokenizer {
		if (instance == null) instance = new LiteralTokenizer();
		return instance;
	}
	
	private function new () {
	}
	
	override public function tokenize (state:TokenizeState) :TokenizeState {
		var resultState:TokenizeState = state.newWorkingCopy();
		var pos:Int = resultState.pos;
		
		var quote:String = resultState.xpathStr.charAt(pos);
		if (quote != "'" && quote != '"') {
			// fail
			return resultState;
		}
		
		var valueStartPos:Int = pos+1;
		var c:String;
		do {
			c = resultState.xpathStr.charAt(++pos);
		} while (c != quote && pos < resultState.xpathStr.length-1);
		
		if (c == quote) {
			var value:String = resultState.xpathStr.substr(valueStartPos, pos - valueStartPos);
			resultState.result = [cast(new LiteralToken(value), Token)];
			resultState.pos = skipWhitespace(resultState.xpathStr, pos+1);
		} // else fail

		return resultState;
	}
		
}