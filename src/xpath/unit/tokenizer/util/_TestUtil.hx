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


package xpath.unit.tokenizer.util;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizeState;
import xpath.token.Token;


class AlwaysToken extends Token {
	
	public function new () {
	}
	
}

class AnyCharTokenizer implements Tokenizer {
	
	public function new () {
	}
	
	public function tokenize (state:TokenizeState) :TokenizeState {
		if (state.pos < state.xpathStr.length) {
			var resultState = state.newWorkingCopy();
			++resultState.pos;
			resultState.result = [ cast(new AlwaysToken(), Token) ];
			return resultState;
		} else {
			return state.newWorkingCopy();
		}
	}
	
}

class NeverTokenizer implements Tokenizer {
	
	public function new () {
	}
	
	public function tokenize (state:TokenizeState) :TokenizeState {
		return state.newWorkingCopy();
	}
	
}