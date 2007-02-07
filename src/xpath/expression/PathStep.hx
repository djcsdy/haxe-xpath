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


package xpath.expression;
import xpath.expression.Expression;
import dcxml.Xml;
import xpath.context.Context;
import xpath.type.XPathValue;
import xpath.type.XPathNodeSet;


class PathStep extends Expression {
	
	private var pathStepApi:PathStepApi;
	private var next:PathStep;
	
	
	private function new (pathStepApi:PathStepApi, ?next:PathStep) {
		super(this);
		this.pathStepApi = pathStepApi;
		this.next = next;
	}
	
	public function evaluate (context:Context) :XPathNodeSet {
		var selected:Array<Xml> = pathStepApi.step(context);
		
		if (next == null) {
			return new XPathNodeSet(selected);
		} else {
			var result:Array<Xml> = new Array<Xml>();
			for (i in 0...selected.length) {
				var nextContext:Context = new Context(
					selected[i], i+1, selected.length, context.environment
				);
				var tmpResult:XPathNodeSet = next.evaluate(nextContext);
				result = result.concat(tmpResult.getNodes());
			}
			return  new XPathNodeSet(result);
		}
	}
	
}

typedef PathStepApi = {
	private function step (context:Context) :Array<Xml>;
}