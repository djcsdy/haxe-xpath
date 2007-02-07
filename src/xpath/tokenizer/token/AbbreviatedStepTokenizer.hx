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
import xpath.token.AxisToken;
import xpath.token.TypeTestToken;


class AbbreviatedStepTokenizer extends TokenTokenizer {
	
	private static var instance:AbbreviatedStepTokenizer;
	
	
	public static function getInstance () :AbbreviatedStepTokenizer {
		if (instance == null) instance = new AbbreviatedStepTokenizer();
		return instance;
	}
	
	private function new () {
	}
	
	override public function tokenize (state:TokenizeState) :TokenizeState {
		var resultState:TokenizeState = state.newWorkingCopy();
		var pos:Int = resultState.pos;
		
		if (resultState.xpathStr.substr(pos, 2) == "..") {
			// .. is an abbreviation for parent::node()
			resultState.result = [ cast(new AxisToken(Parent), Token), new TypeTestToken(Node) ];
			resultState.pos = skipWhitespace(resultState.xpathStr, pos+2);
		} else if (resultState.xpathStr.charAt(pos) == ".") {
			// . is an abbreviation for self::node()
			resultState.result = [ cast(new AxisToken(Self), Token), new TypeTestToken(Node) ];
			resultState.pos = skipWhitespace(resultState.xpathStr, pos+1);
		} // else fail
		
		return resultState;
	}
	
}