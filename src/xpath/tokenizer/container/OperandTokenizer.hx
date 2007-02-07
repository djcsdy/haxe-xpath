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


package xpath.tokenizer.container;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizeState;
import xpath.tokenizer.util.Disjunction;
import xpath.tokenizer.container.PathTokenizer;
import xpath.tokenizer.container.GroupTokenizer;
import xpath.tokenizer.container.FunctionCallTokenizer;
import xpath.tokenizer.container.UnaryOperandTokenizer;
import xpath.tokenizer.token.LiteralTokenizer;
import xpath.tokenizer.token.NumberTokenizer;
import xpath.tokenizer.token.VariableReferenceTokenizer;


class OperandTokenizer implements Tokenizer {
	
	private static var instance:OperandTokenizer;
	
	private var tokenizer:Tokenizer;
	
	
	public static function getInstance () :OperandTokenizer {
		if (instance == null) {
			instance = new OperandTokenizer();
			instance.init();
		}
		return instance;
	}
	
	private function new () {
	}
	
	private function init () :Void {
		tokenizer = new Disjunction([
			cast(PathTokenizer.getInstance(), Tokenizer), GroupTokenizer.getInstance(), LiteralTokenizer.getInstance(),
			NumberTokenizer.getInstance(), FunctionCallTokenizer.getInstance(), VariableReferenceTokenizer.getInstance(),
			UnaryOperandTokenizer.getInstance()
		]);
	}
	
	public function tokenize(state:TokenizeState):TokenizeState {
		return tokenizer.tokenize(state);
	}
	
}